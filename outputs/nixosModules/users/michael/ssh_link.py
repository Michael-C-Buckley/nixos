"""
Simple script to link the active yubikey so that key stubs are
available to SSH configs, which are fixed and not dynamic

It takes 1 arg, and that is the location of ykman so that the
path can be dynamically changed when needed,
like with nixos that I use
"""
import sys
from subprocess import run
from pathlib import Path
from os import makedirs
from getpass import getuser

ykman = sys.argv[1] if len(sys.argv) > 1 else "ykman"
print(f"Using ykman: {ykman}")

if yubikeys := run(
    [ykman, "list", "--serials"], capture_output=True, text=True, check=True
):
    last3 = yubikeys.stdout.strip()[5:]
    print(f"Using SN: {last3}")
else:
    sys.exit(1)

user = getuser()

stub_dir = Path(f"/home/{user}/.ssh/sk")
active_dir = Path(f"/home/{user}/.ssh/active")

print(repr(last3))
print(repr(str(stub_dir)))
print(stub_dir.exists())
print(list(stub_dir.iterdir()))

stubs = list(stub_dir.glob(f"*{last3}*"))
print(stubs)

makedirs(active_dir, exist_ok=True)

for stub in stubs:
    stub_filename = str(stub).split("/")[-1]
    stublink = stub_filename.split(f"_{last3}_")[-1]
    link = active_dir / stublink
    link.unlink(missing_ok=True)
    link.symlink_to(stub)
    print(f"Linked {stub_filename}")

# Link an additional stub to a default location
default_sk = Path(f"/home/{user}/.ssh/id_ed25519_sk")
external = Path(f"/home/{user}/.ssh/sk/id_ed25519_sk_rk_{last3}_external")
default_sk.unlink(missing_ok=True)
default_sk.symlink_to(external)
