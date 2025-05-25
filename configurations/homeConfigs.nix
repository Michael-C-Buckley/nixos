# Legacy conversion output where the specific host is
# I maintain a generic config and some host-specific ones
# HOWEVER, I have mostly moved to Hjem for NixOS hosts
{self, overlays}: let
  inherit (self) inputs;
  # For now, I only use with on X86
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {allowUnfree = true;};
  };

  hmConfig = modules:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit self inputs overlays;};
      inherit pkgs;
      modules = [./user/home.nix] ++ modules;
    };

  hmHostConfig = host:
    hmConfig [
      ./user/hosts/${host}
      ./user/hosts/${host}/home.nix
    ];

  hosts = [
    "wsl"
  ];
in
  {
    "michael" = hmConfig [];
  }
  // builtins.listToAttrs (map (host: {
      name = host;
      value = hmHostConfig {inherit host;};
    })
    hosts)
