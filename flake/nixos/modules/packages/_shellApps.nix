# Some simple shell utilities I use
{pkgs}: let
  gpg-sha = bits:
    pkgs.writeShellApplication {
      name = "gpg${bits}";
      runtimeInputs = [pkgs.gnupg];
      checkPhase = "";
      text = ''
        exec gpg --digest-algo SHA${bits} "$@"
      '';
    };
in [
  (gpg-sha "256")
  (gpg-sha "384")
]
