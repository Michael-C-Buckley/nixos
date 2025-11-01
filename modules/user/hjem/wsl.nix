{config, ...}: {
  flake.modules.nixos.hjem-wsl = {
    imports = with config.flake.modules.nixos; [
      hjem-default
      hjem-cursor
      hjem-helix
    ];
  };
}
