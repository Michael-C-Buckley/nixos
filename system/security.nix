{
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = with inputs; [
    ragenix.nixosModules.default
    sops-nix.nixosModules.sops
    nix-secrets.nixosModules.ssh
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/home/michael/.ssh/id_ed25519"
    "/root/.ssh/id_ed25519"
  ];

  sops.age.keyFile = "/etc/sops/age/host.txt";

  # WIP: Age not working on desktop
  # services.resolved.enable = true;
  # environment.etc."systemd/resolved.conf".source = mkForce config.age.secrets.dns.path;

  security = {
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = mkDefault false;
    };
  };

  # Revoke printing for its flaws over the years
  services = {
    printing.enable = false;
    openssh.enable = mkDefault true;
    vscode-server.enable = mkDefault true; # Slotted to be phased out
  };

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22 53 179];
      allowedUDPPorts = [53];
    };
  };
}
