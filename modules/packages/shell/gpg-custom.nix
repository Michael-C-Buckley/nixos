{config, ...}: let
  inherit (config.flake) packages;
in {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.gpg-custom = pkgs.writeShellApplication {
      name = "gpg-custom";
      runtimeInputs = [pkgs.gnupg packages.${pkgs.system}.gpg-find-key];
      checkPhase = "";
      text = ''
        exec ${lib.getExe pkgs.gnupg} -u $(${lib.getExe packages.${pkgs.system}.gpg-find-key})! "$@"
      '';
    };
  };
}
