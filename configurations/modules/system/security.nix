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
    gnupg
    pinentry-curses
    opensc
  ];

  yubikeyPkgs = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
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

  environment.systemPackages = gpgPkgs ++ optionals notCloud yubikeyPkgs;

  security = {
    apparmor.enable = true;
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = mkDefault false;
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = mkIf notCloud true;
  };

  services = {
    pcscd.enable = mkIf notCloud true;
    yubikey-agent.enable = mkIf notCloud true;
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
