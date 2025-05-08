{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce mkIf optionals;

  notCloud = config.system.preset != "cloud";

  gpgPkgs = with pkgs; [
    gnupg # gpg, gpg-agent, scdaemon
    pinentry-curses # or pinentry-gtk2
    yubikey-manager # “ykman” CLI / GUI
    yubikey-personalization
    yubico-piv-tool
    opensc # PKCS#11 engine for OpenSSL
  ];

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

  environment.systemPackages = optionals notCloud gpgPkgs;

  security = {
    apparmor.enable = true;
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = mkDefault false;
    };
  };

  services = {
    pcscd.enable = mkIf notCloud true;
    printing.enable = false; # Revoke printing for its flaws over the years
    openssh.enable = mkDefault true;
    udev.packages = optionals notCloud [pkgs.yubikey-personalization];
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
