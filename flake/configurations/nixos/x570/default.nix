{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hyprland.nix
  ];

  system = {
    preset = "desktop";
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs.enable = true;
  };

  environment.systemPackages = with pkgs; [
    talosctl
    devenv
  ];

  programs = {
    cosmic.enable = true;
    hyprland.enable = true;
  };

  features = {
    michael = {
      extendedGraphical = true;
      hyprland.enable = true;
    };
    autoLogin = true;
    displayManager = "greetd";
    gaming.enable = true;
    pkgs.fonts = true;
  };

  services = {
    flatpak.enable = true;
    nix-serve.enable = true;
    k3s.enable = true;
    unbound.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    incus.enable = true;
    libvirtd.enable = true;
    gns3.enable = true;
  };
}
