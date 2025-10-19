{
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.gpg-custom = pkgs.writeShellApplication {
      name = "gpg-custom";
      runtimeInputs = [pkgs.gnupg self'.packages.gpg-find-key];
      checkPhase = "";
      text = ''
        exec ${lib.getExe pkgs.gnupg} -u $(${lib.getExe self'.packages.gpg-find-key})! "$@"
      '';
    };
  };
}
