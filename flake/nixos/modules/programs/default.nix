{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./dconf.nix
  ];

  programs = {
    fish.enable = true;
    vim.enable = true;
    nano.enable = false;
    neovim.defaultEditor = true;

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
