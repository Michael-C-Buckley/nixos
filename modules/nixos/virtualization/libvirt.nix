{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optionals;
  gfx = config.hardware.graphics.enable;
  extraGroups = [ "libvirtd" ];
in
{
  environment.systemPackages =
    with pkgs;
    optionals gfx [
      virt-manager
      virt-viewer
      tigervnc
    ];

  users.users = {
    michael = { inherit extraGroups; };
    shawn = { inherit extraGroups; };
  };

  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = lib.mkDefault (builtins.attrNames config.networking.bridges);
    parallelShutdown = 5;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
}
