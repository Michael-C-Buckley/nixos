{config, ...}: {
  flake.modules.darwin.m1 = {pkgs, ...}: {
    imports = with config.flake.modules.darwin; [
      ssh-agent
    ];

    environment.systemPackages = with pkgs; [orbstack];

    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
