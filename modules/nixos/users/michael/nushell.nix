{config, ...}: let
  inherit (config.flake.wrappers) mkNushell;
in {
  flake.modules.nixos.michael-nushell = {
    config,
    pkgs,
    ...
  }: let
    shellPkg = mkNushell {
      inherit pkgs;
      env = config.hjem.users.michael.environment.sessionVariables;
    };
    shell = "${shellPkg}${shellPkg.shellPath}";
  in {
    # An alias for anyone user to be able to jump into my shell
    environment.shellAliases.msh = shell;

    users.users.michael = {
      inherit shell;
      packages = [shellPkg];
    };
  };
}
