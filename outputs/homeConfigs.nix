# Legacy conversion output where the specific host is
# I maintain a generic config and some host-specific ones
# HOWEVER, I have mostly moved to Hjem for NixOS hosts
{inputs}: let
  # For now, I only use with on X86
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    config = {allowUnfree = true;};
  };

  hmConfig = modules:
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit inputs;};
      inherit pkgs;
      modules = [../home/home.nix] ++ modules;
    };

  hmHostConfig = host:
    hmConfig [
      ../home/hosts/${host}
      ../home/hosts/${host}/home.nix
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
