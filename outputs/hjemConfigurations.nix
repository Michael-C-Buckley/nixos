{inputs, ...}: let
  inherit (inputs) self hjem hjem-rum;

  # This assists me in differentiating the configs I'll need per-host
  mkHjemCfg = {
    modules ? [],
    nvfVer ? "nvf",
    system ? "x86_64-linux",
  }: {
    # My "Hjem" modules are actually NixOS modules
    #  This is the body of the NixOS module getting assembled
    #  with the various user components I have declared
    imports =
      [
        hjem.nixosModules.hjem
        ../modules/user/hjem/default.nix
      ]
      ++ modules;

    # I use Hjem-Rum and the SMFH linker
    hjem = {
      extraModules = [hjem-rum.hjemModules.default];
      linker = hjem.packages.${system}.smfh;
    };

    users.users.michael.packages = [self.packages.${system}.${nvfVer}];
  };
in {
  flake.hjemConfigurations = {
    # Full Graphical Environment configs
    default = mkHjemCfg {modules = [../modules/user/hjem/extended.nix];};

    # Stripped bare, suitable for cloud or VMs
    minimal = mkHjemCfg {nvfVer = "nvf-minimal";};

    minimal-arm = _:
      mkHjemCfg {
        nvfVer = "nvf-minimal";
        system = "aarch64-linux";
      };

    # Bare metal servers, slightly above the stripped version including a few extras
    server = mkHjemCfg {
      nvfVer = "nvf-minimal";
      modules = [../modules/user/hjem/server.nix];
    };

    # As name implies
    wsl = mkHjemCfg {};

    # A simple root user profile
    # Requires externally defined Hjem and Hjem-Rum if used not with my configs
    root = ../modules/user/hjem/root.nix;
  };
}
