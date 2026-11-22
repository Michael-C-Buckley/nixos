{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      cage
      pcmanfm
      pavucontrol
      wavemon
      gparted
      kitty
      nushell
      gammastep
      wireshark
      winbox
      kubectl
      talosctl
      signal-desktop
      codex
      mpv
      imv
      xarchiver
      ffmpegthumbnailer
      nix-tree
      jq
      yq
      curl
      zathura
      ;
    ns = pkgs.callPackage ../../../packages/ns { };
    inherit (inputs.helium.packages.${system}) helium-widevine;
  };
}
