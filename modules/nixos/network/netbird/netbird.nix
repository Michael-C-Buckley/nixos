{
  flake.modules.nixos.netbird = {
    services.netbird = {
      enable = true;
      ui.enable = true;
    };
  };
}
