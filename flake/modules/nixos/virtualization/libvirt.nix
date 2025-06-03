{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkOption types;
  virtCfg = config.virtualisation.libvirtd;
in {
  options.virtualisation.libvirtd = {
    addGUIPkgs = mkOption {
      type = types.bool;
      default = virtCfg.enable;
      description = "Add graphical support packages for VMs.";
    };
    # WIP: Create a config option in users for power users
    users = mkOption {
      type = types.listOf types.str;
      default = ["root" "michael" "shawn"];
      description = "List of users to add the `KVM` group to.";
    };
  };

  config = {
    # WIP: add these to the users
    environment.systemPackages = with pkgs;
      lib.optionals virtCfg.addGUIPkgs [
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
      allowedBridges = mkDefault ["br0"];
      parallelShutdown = mkDefault 5;
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
