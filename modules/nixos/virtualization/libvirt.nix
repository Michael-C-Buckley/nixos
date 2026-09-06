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

  # Libvirt 10.2+ requires a systemd-creds passed credential by default, which can be disabled
  # it can be just randomly created but I've gone and actually provisioned and declared it
  # This secret is valueless to me, so it's presented in the clear
  systemd.services.libvirtd.serviceConfig.SetCredential = [
    "secrets-encryption-key:c5e1b3cb68f94db5aa6060d2ebaa28ff"
  ];

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
