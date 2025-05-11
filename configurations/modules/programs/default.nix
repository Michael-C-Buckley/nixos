{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
  useWireshark = config.programs.wireshark.enable;
in {
  imports = [
    ./direnv.nix
    ./winbox.nix
  ];

  # Add Wireshark if enabled
  users.powerUsers.groups =
    if useWireshark
    then ["wireshark"]
    else [];

  programs = {
    fish.enable = true;
    wireshark.enable = mkDefault true;
    zsh.enable = true;
    neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    nh = {
      enable = true;
      flake = mkDefault "/etc/nixos";
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      enableBrowserSocket = true;
    };
  };
}
