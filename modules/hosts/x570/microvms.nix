{config, ...}: {
  flake.modules.nixos.x570 = {
    microvm.vms.devbox.config = config.flake.modules.nixos.devbox;
  };
}
