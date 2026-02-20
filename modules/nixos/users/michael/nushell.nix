{config, ...}: let
  inherit (config.flake.wrappers) mkNushell;
in {
  flake.modules.nixos.michael-nushell = {
    config,
    pkgs,
    ...
  }: let
    shell = mkNushell {
      inherit pkgs;
      env = config.hjem.users.michael.environment.sessionVariables;
    };
  in {
    users.users.michael = {
      shell = "${shell}${shell.shellPath}";
      packages = [shell];
    };
  };
}
