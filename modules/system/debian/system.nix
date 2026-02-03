{
  flake.modules.systemManager.debian = {
    system-manager.allowAnyDistro = true;

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
