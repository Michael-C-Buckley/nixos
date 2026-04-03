{config, ...}: {
  flake.modules.darwin.m1 = {
    imports = with config.flake.modules.darwin; [
      ssh-agent
    ];

    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
