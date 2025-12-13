{
  flake.modules.nixos.incus = {pkgs, ...}: {
    # Incus is bested used with these modules available
    boot.kernelModules = ["apparmor" "virtiofs" "9p" "9pnet_virtio"];
    # Incus will prefer Red Hat's Virtiofs over 9P
    environment.systemPackages = [pkgs.virtiofsd];

    custom.impermanence.cache.directories = ["/var/lib/incus"];

    virtualisation.incus = {
      enable = true;
      package = pkgs.incus; # Stable version is old
      ui.enable = true;
    };
  };
}
