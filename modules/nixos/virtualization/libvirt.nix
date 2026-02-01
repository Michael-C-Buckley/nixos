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
    custom.impermanence = lib.mkIf config.custom.impermanence.var.enable {
      cache = {
        directories = ["/var/lib/libvirt"];
        allUsers.directories = optionals gfx [".cache/virt-manager"];
      };
    };

    environment.systemPackages = with pkgs;
      optionals gfx [
        virt-manager
        virt-viewer
        tigervnc
      ];

    users.powerUsers.groups = ["libvirtd"];

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
