{
  host = {
    impermanence.cache.directories = [
      "/var/lib/libvirt"
    ];
    graphicalPackages = [
      "virt-manager"
      "virt-viewer"
      # "tigervnc" # Broken in nixpkgs update, removing for now
    ];
  };

  flake.modules.nixosModules.libvirt = {
    config,
    pkgs,
    ...
  }: {
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

    services.cockpit = {
      inherit (config.virtualisation.libvirtd) enable;
      openFirewall = config.services.cockpit.enable;
    };
  };
}
