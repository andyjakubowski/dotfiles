"""Exercise login-shell configuration with no writes to host shell settings."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "setup_zsh.zsh"


class ZshSetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.prefix = self.root / "homebrew prefix"
        (self.prefix / "bin").mkdir(parents=True)
        self.log = self.root / "calls"
        self.env = dict(os.environ, HOME=str(self.root), ZDOTDIR=str(self.root),
                        PATH=str(self.root) + ":/usr/bin:/bin",
                        SHELL=str(self.prefix / "bin/zsh"),
                        TEST_PREFIX=str(self.prefix), TEST_LOG=str(self.log),
                        REGISTERED="0")
        self.stub(self.root / "brew", 'echo "$TEST_PREFIX"')
        self.stub(self.root / "grep", 'echo "grep $*" >> "$TEST_LOG"; exit "$((1 - REGISTERED))"')
        self.stub(self.root / "sudo", 'echo "sudo $*" >> "$TEST_LOG"; /bin/cat >> "$TEST_LOG"')
        self.stub(self.root / "chsh", 'echo "chsh argc=$# $*" >> "$TEST_LOG"')
        self.stub(self.prefix / "bin/zsh", 'exit 0')

    def stub(self, path, body):
        path.write_text("#!/bin/sh\n" + body + "\n")
        path.chmod(0o755)

    def run_setup(self):
        result = subprocess.run(["/bin/zsh", "-f", str(SCRIPT)],
                                env=self.env, capture_output=True, text=True)
        log = self.log.read_text() if self.log.exists() else ""
        self.assertNotIn("sudo ln", log)
        self.assertNotIn("/private/var/select/sh", log)
        return result, log

    def test_registers_missing_shell_without_changing_system_sh(self):
        result, log = self.run_setup()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("sudo tee -a /etc/shells", log)
        self.assertIn(str(self.prefix / "bin/zsh") + "\n", log)
        self.assertNotIn("chsh", log)

    def test_already_selected_registered_shell_is_unchanged(self):
        self.env["REGISTERED"] = "1"
        result, log = self.run_setup()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("sudo", log)
        self.assertNotIn("chsh", log)

    def test_selects_user_shell_with_space_in_prefix(self):
        self.env.update(SHELL="/bin/zsh", REGISTERED="1")
        result, log = self.run_setup()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("chsh argc=2 -s " + str(self.prefix / "bin/zsh"), log)

    def test_missing_homebrew_shell_fails_before_changes(self):
        (self.prefix / "bin/zsh").unlink()
        result, log = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(log, "")
        self.assertIn("Homebrew zsh is missing", result.stderr)


if __name__ == "__main__":
    unittest.main()
