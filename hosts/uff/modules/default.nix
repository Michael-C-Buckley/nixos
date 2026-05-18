{flake, ...}: {
  imports = with flake.modules.nixos;
    [
      serverPreset
      systemd-boot
      impermanence
      systemd-credentials

      # Network
      dnscrypt-proxy
      ntp
      wifi-home
      homelabPreset
    ]
    ++ [
      ./network
      ./hardware.nix
      ./k3s.nix
    ];

  sops.defaultSopsFile = "/etc/secrets/clusters/uff/uff.yaml";
}
