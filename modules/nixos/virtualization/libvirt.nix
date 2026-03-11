{
  flake.modules.nixos.libvirt = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) optionals;
    gfx = config.hardware.graphics.enable;
  in {
    environment.systemPackages = with pkgs;
      optionals gfx [
        virt-manager
        virt-viewer
        tigervnc
      ];

    users.powerUsers.groups = ["libvirtd"];

    # Libvirt 10.2+ requires a systemd-creds passed credential
    # it can be just randomly created but I've gone and actually provisioned and declared it
    systemd.services.libvirtd.serviceConfig.LoadCredential = [
      "secrets-encryption-key:${config.sops.secrets.libvirt-key.path}"
    ];
    # I use 1 key among the various hosts, it's low priority but persisted in case I ever need to access anything
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
}
