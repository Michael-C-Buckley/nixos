{
  flake.modules.nixos.libvirt = {
    config,
    lib,
    pkgs,
    ...
  }: {
    custom.impermanence.cache.directories = [
      "/var/lib/libvirt"
    ];

    environment.systemPackages = with pkgs;
      lib.optionals config.hardware.graphics.enable [
        virt-manager
        virt-viewer
        tigervnc
      ];

    users.powerUsers.groups = ["libvirt"];

    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = ["br0"];
      parallelShutdown = 5;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };
}
