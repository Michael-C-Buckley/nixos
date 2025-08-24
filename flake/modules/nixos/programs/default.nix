{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [inputs.schizofox.nixosModules.default];
  programs = {
    fish.enable = true;
    neovim.defaultEditor = true;
    zsh.enable = true;
    schizofox.enable = true;

    nh = {
      enable = true;
      flake = mkDefault "/etc/nixos";
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      direnvrcExtra = ''
        warn_timeout=0
        hide_env_diff=true
      '';
    };
  };
}
