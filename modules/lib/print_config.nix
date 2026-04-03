{
  flake.custom.functions.printConfig = {
    pkgs,
    name,
    cfg,
  }:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [pkgs.bat];
      text = ''
        bat "$@" ${cfg}
      '';
    };
}
