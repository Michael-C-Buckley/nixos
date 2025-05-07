{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;

in {
  imports = with inputs; [
    sops-nix.nixosModules.sops
    nix-secrets.nixosModules.ssh
    nix-secrets.nixosModules.common
  ];

  services.resolved.enable = true;
  environment.etc."systemd/resolved.conf" = {
    source = mkForce config.sops.secrets.dns.path; # There is a conflict default source
    mode = "0644";
  };

  security = {
    apparmor.enable = true;
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = mkDefault false;
    };
  };

  services = {
    printing.enable = false; # Revoke printing for its flaws over the years
    openssh.enable = mkDefault true;
    vscode-server.enable = mkDefault true; # Slotted to be phased out
  };

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [22 53];
      allowedUDPPorts = [53];
    };
  };
}
