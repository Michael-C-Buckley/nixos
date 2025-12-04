{
  flake.modules.nixos.netbird = {pkgs, ...}: {
    custom.impermanence.persist.directories = ["/var/lib/netbird"];
    environment.systemPackages = [pkgs.netbird];
    services.netbird = {
      enable = true;
      ui.enable = true;
    };
  };
}
