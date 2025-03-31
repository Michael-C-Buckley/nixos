{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  virtCfg = config.custom.virtualisation.libvirt;
in {
  options.custom.virtualisation.libvirt = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable libvirt on the host.";
    };
    addPkgs = mkOption {
      type = types.bool;
      default = true;
      description = "Add graphical support packages for VMs.";
    };
    users = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of users to add the `KVM` group to.";
    };
    bridges = mkOption {
      type = types.listOf types.str;
      default = ["br0"];
      description = "Name of the bridge device to bind for Libvirt.";
    };
  };

  config = mkIf virtCfg.enable {
    environment.systemPackages = with pkgs;
      lib.optionals virtCfg.addPkgs [
        virt-viewer
        virt-manager
        tigervnc
      ];

    users.users = lib.listToAttrs (map (user: {
        name = user;
        value = {extraGroups = ["kvm"];};
      })
      virtCfg.users);

    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = lib.mkDefault virtCfg.bridges;
      parallelShutdown = 5;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd];
        };
      };
    };
  };
}
