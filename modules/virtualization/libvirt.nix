{
  config,
  pkgs,
  lib,
  ...
}: let
  virtCfg = config.custom.virtualisation.libvirt;
  ovmfList = [
    (pkgs.OVMF.override {
      secureBoot = true;
      tpmSupport = true;
    })
    .fd
  ];
in {
  options.custom.virtualisation.libvirt = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable libvirt on the host.";
    };
    addPkgs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Add graphical support packages for VMs.";
    };
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users to add the `KVM` group to.";
    };
    bridges = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["br0"];
      description = "Name of the bridge device to bind for Libvirt.";
    };
  };

  config = {
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
          packages = ovmfList;
        };
      };
    };
  };
}
