"""Exercise the installer with fake runtimes; never install global packages."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "setup_node.zsh"


class NodeSetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.bin = self.root / "commands"
        self.bin.mkdir()
        self.prefix = self.root / "node runtime"
        self.log = self.root / "commands.log"
        self.env = dict(os.environ, HOME=str(self.root), ZDOTDIR=str(self.root),
                        PATH=str(self.bin) + ":/usr/bin:/bin",
                        N_PREFIX=str(self.prefix), TEST_LOG=str(self.log))
        self.write(self.bin / "npm", 'echo WRONG-NPM >> "$TEST_LOG"; exit 99')
        self.write(self.bin / "n", """
echo n >> "$TEST_LOG"
[ "${FAIL_N:-0}" = 0 ] || exit 42
[ "${EMPTY_N:-0}" = 0 ] || exit 0
mkdir -p "$N_PREFIX/bin"
cp "$FAKE_RUNTIME" "$N_PREFIX/bin/node"
cp "$FAKE_RUNTIME" "$N_PREFIX/bin/npm"
""")
        runtime = self.root / "runtime"
        self.write(runtime, 'echo "$0 $*" >> "$TEST_LOG"; echo v-test')
        self.env["FAKE_RUNTIME"] = str(runtime)

    def write(self, path, content):
        path.write_text("#!/bin/sh\n" + content + "\n")
        path.chmod(0o755)

    def run_setup(self):
        result = subprocess.run(["/bin/zsh", "-f", str(SCRIPT)],
                                env=self.env, capture_output=True, text=True)
        log = self.log.read_text() if self.log.exists() else ""
        self.assertNotIn("WRONG-NPM", log)
        return result, log

    def test_clean_install_uses_selected_prefix_with_spaces(self):
        result, log = self.run_setup()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("n", log.splitlines())
        self.assertIn(str(self.prefix / "bin/npm") + " install --global trash-cli", log)

    def test_existing_runtime_skips_n(self):
        (self.prefix / "bin").mkdir(parents=True)
        for command in ["node", "npm"]:
            self.write(self.prefix / "bin" / command, 'echo "$0 $*" >> "$TEST_LOG"; echo v-test')
        result, log = self.run_setup()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("n", log.splitlines())
        self.assertIn("install --global yarn", log)

    def test_failed_install_does_not_install_packages(self):
        self.env["FAIL_N"] = "1"
        result, log = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("install --global", log)

    def test_incomplete_install_does_not_fall_back_to_other_npm(self):
        self.env["EMPTY_N"] = "1"
        result, log = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("refusing to use another runtime", result.stderr)

    def test_default_prefix_without_zshenv(self):
        del self.env["N_PREFIX"]
        result, log = self.run_setup()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(str(self.root / ".n/bin/npm"), log)


if __name__ == "__main__":
    unittest.main()
