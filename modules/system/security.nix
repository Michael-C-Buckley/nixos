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
    # There is a conflict default source
    source = mkForce config.sops.secrets.dns.path;
    mode = "0644";
  };

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
