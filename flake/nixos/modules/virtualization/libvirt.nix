{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkOption mkEnableOption types optionals;
  inherit (config.system) impermanence;
  inherit (config.virtualisation) libvirtd;
in {
  options.virtualisation.libvirtd = {
    addGUIPkgs = mkEnableOption "Add graphical support packages for VMs.";
    # WIP: Create a config option in users for power users
    users = mkOption {
      type = types.listOf types.str;
      default = ["root" "michael" "shawn"];
      description = "List of users to add the `KVM` group to.";
    };
  };

  config = {
    # WIP: add these to the users
    environment = {
      persistence."/cache".directories = optionals impermanence.enable ["/var/lib/libvirt"];
      systemPackages = with pkgs;
        lib.optionals libvirtd.addGUIPkgs [
          virt-viewer
          virt-manager
          # tigervnc # Broken in nixpkgs update, removing for now
        ];
    };

    users.users = lib.listToAttrs (map (user: {
        name = user;
        value = {extraGroups = ["kvm" "libvirt"];};
      })
      libvirtd.users);

    virtualisation.libvirtd = {
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
