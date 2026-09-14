{
  self,
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.default
    ./base.nix
    ./metal.nix
    ./graphical/umbriel.nix
    ./graphical/tuigreet.nix
    ./network/tailscale.nix
    ./packages/network.nix
    ./security/tpm2.nix
    ./security/yubikey.nix
    ./virtualization/agentbox.nix
    ./virtualization/containerlab.nix
    ./virtualization/libvirt.nix
  ];

  boot = {
    loader.systemd-boot.enable = false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  systemd.network.wait-online.enable = false;

  fonts.packages = with pkgs; [
    dejavu_fonts
    commit-mono
    vista-fonts
    font-awesome
    geist-font
    ibm-plex
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.symbols-only
    nerd-fonts.lilex
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Wrapped packages for my user
  users.users.michael.packages = builtins.attrValues {
    inherit (self.packages.${system})
      zed
      helix
      kitty
      ;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # System Utilities
      cage
      pavucontrol # Pulse Volume control
      wavemon

      # Terminal
      alacritty
      nushell
      yazi
      herdr
      tmux
      zellij

      # Utility
      wmenu
      gammastep
      termshark
      tshark
      putty
      winbox4
      kubectl
      talosctl

      # Communication
      signal-desktop
      legcord
      materialgram

      # Productivity
      obsidian
      flow-control
      codex
      opencode

      #development
      lazygit
      tig
      delta
      hunk
      gh
      nix-tree
      jq
      yq
      curl
      ;
    inherit (self.packages.${system})
      ns
      ;

    inherit (inputs.helium.packages.${system}) helium-widevine;
  };
}
