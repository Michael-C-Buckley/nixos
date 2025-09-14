{inputs, ...}: let
  inherit (inputs) self hjem;
  mkHjemCfg = {
    modules ? [],
    nvfVer ? "nvf",
    system ? "x86_64-linux",
  }: {
    imports =
      [
        hjem.nixosModules.hjem
        ../flake/user/hjem/default.nix
      ]
      ++ modules;

    hjem.linker = hjem.packages.${system}.smfh;
    users.users.michael.packages = [self.packages.${system}.${nvfVer}];
  };
in {
  flake.hjemConfigurations = {
    # Full Graphical Environment configs
    default = _: mkHjemCfg {modules = [../flake/user/hjem/extended.nix];};

    # Stripped bare, suitable for cloud or VMs
    minimal = _: mkHjemCfg {nvfVer = "nvf-minimal";};

    minimal-arm = _:
      mkHjemCfg {
        nvfVer = "nvf-minimal";
        system = "aarch64-linux";
      };

    # Bare metal servers, slightly above the stripped version including a few extras
    server = _:
      mkHjemCfg {
        nvfVer = "nvf-minimal";
        modules = [../flake/user/hjem/server.nix];
      };

    # As name implies
    wsl = _: mkHjemCfg {};
  };
}
