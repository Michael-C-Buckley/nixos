{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.darwin.m1 = {pkgs, ...}: {
    imports = [
      flake.modules.darwin.ssh-agent
      flake.hjemConfigs.zed
    ];

    environment.systemPackages = with pkgs; [orbstack];

    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
