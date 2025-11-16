{config, ...}: {
  flake.hjemConfig.wsl = {
    imports = with config.flake.hjemConfig; [
      default
      cursor
      helix
    ];
  };
}
