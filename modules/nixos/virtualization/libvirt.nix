{config, ...}: let
  inherit (config) flake;
  libvirtUnits = config.flake.custom.lib.mkJournalNamespace "libvirt" [
    "libvirtd"
    "libvirt-guests"
    "virtlogd"
    "virtlockd"
  ];
in {
  flake.modules.nixos.libvirt = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.custom.journald) libvirt;
    gfx = config.hardware.graphics.enable;
  in {
    options.custom.journald.libvirt = flake.custom.lib.mkJournalOptions;

    config = {
      environment = {
        etc."systemd/journald@libvirt.conf".text = flake.custom.lib.mkJournalEtcFile libvirt;
        systemPackages = with pkgs;
          lib.optionals gfx [
            virt-manager
            virt-viewer
            tigervnc
          ];
      };

      users.powerUsers.groups = ["libvirtd"];

      systemd.services =
        # Merge secret with the logging update
        lib.recursiveUpdate
        {
          # Libvirt 10.2+ requires a systemd-creds passed credential
          # it can be just randomly created but I've gone and actually provisioned and declared it
          libvirtd.serviceConfig.LoadCredential = [
            "secrets-encryption-key:${config.sops.secrets.libvirt-key.path}"
          ];
        }
        libvirtUnits;

      # I use 1 key among the various hosts, it's low priority but persisted in case I ever need to access anything
      # The default NixOS has is to generate fresh random ones, I'll use static instead
      sops.secrets.libvirt-key.sopsFile = "/etc/secrets/common/common.yaml";

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
    };
  };
}
