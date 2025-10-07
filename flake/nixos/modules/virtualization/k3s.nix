{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf optionals;
  inherit (config.services) k3s;
  inherit (config.system) impermanence;
in {
  # Following along at: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
  networking.firewall = {
    allowedTCPPorts = [6443 2379 2380];
    allowedUDPPorts = [8472];
  };

  services.k3s = {
    role = "server";
  };

  environment = mkIf k3s.enable {
    persistence."/persist".directories = optionals impermanence.enable [
      "/var/lib/rancher/k3s"
    ];

    systemPackages = with pkgs;
      optionals k3s.enable [
        kubectl
        helm
        k9s
      ];
  };
}
