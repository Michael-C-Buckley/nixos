{
  pkgs,
  lib,
  gpg-find-key,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs) gnupg;
in
  pkgs.writeShellApplication {
    name = "gpg-custom";
    runtimeInputs = [gnupg gpg-find-key];
    checkPhase = "";
    text = ''
      exec ${getExe gnupg} -u $(${getExe gpg-find-key})! "$@"
    '';
  }
