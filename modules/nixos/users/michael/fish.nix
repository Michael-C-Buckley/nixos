# My wrapped fish set as my shell
{config, ...}: let
  inherit (config.flake.wrappers) mkFish;
in {
  flake.modules.nixos.michael-fish = {
    config,
    pkgs,
    ...
  }: let
    shell = mkFish {
      inherit pkgs;
      env = config.hjem.users.michael.environment.sessionVariables;
    };
  in {
    programs.fish = {
      enable = true;
      useBabelfish = true;
      extraCompletionPackages = config.users.users.michael.packages;
    };
    users.users.michael.shell = "${shell}${shell.shellPath}";
  };
}
