{config, ...}: {
  flake.modules.hjem.wsl = {
    imports = with config.flake.modules.hjem; [
      default
      cursor
      helix
    ];
  };
}
