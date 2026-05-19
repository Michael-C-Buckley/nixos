{
  pkgs,
  flake,
  ...
}: let
  fpkgs = flake.packages.${pkgs.stdenv.hostPlatform.system};
in {
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      # System
      killall
      expect
      # Performance
      btop
      # Hardware
      usbutils
      pciutils
      # Editors
      neovim
      # Machine Utilities
      gptfdisk
      parted
      # CLI
      bat
      duf
      dust
      eza
      fd
      file
      fzf
      git
      ripgrep
      sops
      age
      ;

    inherit (fpkgs) ns;
  };
}
