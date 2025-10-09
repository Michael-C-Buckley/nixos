{
  hosts = {
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
      enable = mkDefault true;
      allowedBridges = mkDefault ["br0"];
      parallelShutdown = mkDefault 5;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };

    services.cockpit = {
      enable = mkDefault config.virtualisation.libvirtd.enable;
      openFirewall = mkDefault config.services.cockpit.enable;
    };
  };
}
