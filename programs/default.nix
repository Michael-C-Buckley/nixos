_: {
  imports = [
    ./direnv.nix
    ./winbox.nix
  ];

  programs = {
    fish.enable = true;
    wireshark.enable = true;
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
