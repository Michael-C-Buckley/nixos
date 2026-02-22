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
      extraAliases =
        if config.security.doas.enable
        then {sudo = "doas";}
        else {};
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
