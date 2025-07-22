{
  config,
  lib,
  ...
}: {
  services.cockpit = {
    enable = lib.mkDefault config.virtualisation.libvirtd.enable;
    openFirewall = true;
  };
}
