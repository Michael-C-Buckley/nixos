{pkgs, ...}: {
  imports = [
    ./direnv.nix
    ./winbox.nix
  ];

  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    wireshark.enable = true;
  };
}
