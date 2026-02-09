# WARNING: Highly Unstable and Experimental
# System-Manager is a new tool from Numtide for managing the base system
# of non-NixOS systems somewhat conceptually to what Home-Manager does
# for users
#
# These are *extremely* experimental and I'm just testing
# some capabilities and rather crazy ideas, they should
# not be taken seriously
{
  config,
  inputs,
  ...
}: let
  system-manager = import config.flake.npins.system-manager {inherit (inputs) nixpkgs;};
in {
  flake.systemConfigs = {
    debian = system-manager.lib.makeSystemConfig {
      extraSpecialArgs = {inherit inputs;};
      modules = with config.flake.modules.systemManager; [
        nix
        packages
        debian
        #fish # Currently experimental
      ];
    };
  };
}
