{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./direnv.nix
    ./winbox.nix
  ];

  programs = {
    fish.enable = true;
    zsh.enable = true;
    neovim.defaultEditor = true;
    nh = {
      enable = true;
      flake = mkDefault "/etc/nixos";
    };
  };
}
