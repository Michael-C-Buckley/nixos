"""Test workspace defaults without a container engine or Nix daemon."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest


LAUNCHER = Path(__file__).resolve().parents[1] / "agentbox.sh"


class ProjectConfigTest(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.root = Path(tmp.name)
        self.workspace = self.root / "my project"
        self.workspace.mkdir()
        self.config = self.workspace / ".agentbox"
        for engine in ("docker", "podman"):
            stub = self.root / engine
            stub.write_text('#!/bin/sh\nprintf "%s\\n" "${0##*/}" "$@"\n')
            stub.chmod(0o755)

    def launch(self, *args, cwd=None, ok=True):
        p = subprocess.run(
            ["bash", LAUNCHER, *args], cwd=cwd or self.root, capture_output=True,
            text=True, env={"HOME": str(self.root), "PATH": f"{self.root}:{os.environ['PATH']}"},
        )
        self.assertEqual(p.returncode, 0 if ok else 2, p.stderr)
        return p.stdout.splitlines() if ok else p.stderr

    def test_bare_launch_uses_current_workspace(self):
        self.config.write_bytes(b" # comment\r\n\r\n --engine docker\r\n--no-nix\n--target /my src")
        args = self.launch(cwd=self.workspace)
        self.assertEqual(args[:2], ["docker", "run"])
        self.assertEqual(args[-3:], ["--workdir", "/my src", "agentbox:latest"])
        self.assertNotIn("NIX_REMOTE=daemon", args)

    def test_explicit_workspace_cli_overrides_and_relative_binds(self):
        (self.root / ".agentbox").write_text("--not-from-this-directory\n")
        (self.root / "cli file").touch()
        (self.workspace / "binds").mkdir()
        (self.workspace / "binds/list").write_text("../inside file:/listed:ro\n")
        (self.workspace / "inside file").touch()
        self.config.write_text("--no-nix\n--engine podman\n--target /old\n--network project\n"
                               "--ip 192.0.2.1\n--bind inside file:/direct:ro\n--bind-file binds/list\n")
        tail = ["--userns=keep-id", "image", "cmd", "--no-config", "arg with spaces"]
        args = self.launch("--target", "/new", "--network", "none", "--bind", "cli file:/cli",
                           "--engine", "docker", self.workspace, *tail)
        self.assertEqual(args[0], "docker")
        self.assertEqual(args[args.index("--network") + 1], "none")
        self.assertNotIn("--ip", args)
        for dst in ("/direct", "/listed"):
            self.assertIn(f"type=bind,src={self.workspace}/inside file,dst={dst},ro", args)
        self.assertIn(f"type=bind,src={self.root}/cli file,dst=/cli", args)
        self.assertEqual(args[-len(tail)-2:], ["--workdir", "/new", *tail])

    def test_values_are_not_shell_code(self):
        target = "/$(touch SHOULD_NOT_EXIST) *"
        self.config.write_text(f"--no-nix\n--target {target}\n")
        self.assertIn(target, self.launch(self.workspace))
        self.assertFalse((self.root / "SHOULD_NOT_EXIST").exists())

    def test_invalid_and_ignored_config(self):
        for line in ("--target", "--no-nix extra", "--privileged", "image", "--"):
            with self.subTest(line=line):
                self.config.write_text(f"# ignored\n{line}\n")
                self.assertIn(f"{self.config}:2:", self.launch(self.workspace, ok=False))
        self.assertIn("/workspace", self.launch("--no-config", "--no-nix", self.workspace))
        self.config.unlink()
        self.assertIn("/workspace", self.launch("--no-nix", self.workspace))


if __name__ == "__main__":
    unittest.main()
