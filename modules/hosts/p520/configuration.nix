{config, ...}: {
  flake.modules.nixos.p520 = {pkgs, ...}: {
    imports = with config.flake.modules.nixos; [
      serverPreset
      homelabPreset
      network-no-static-default
      containerlab
      lab-network
      libvirt
      netbird
      nvidia
      systemd-credentials
      secrets-nic-rename
    ];

    environment.systemPackages = with pkgs; [
      attic-client
    ];

    virtualisation = {
      libvirtd.enable = true;
    };

    system.stateVersion = "25.11";

    # Allows vscode remote connections to just work
    programs.nix-ld.enable = true;
  };
}
