{flake, ...}: {
  imports = with flake.nixosModules;
    [
      server-preset
      dnscrypt-proxy
      ntp
      wifi-home
    ]
    ++ [
      ./network
      ./hardware.nix
      ./k3s.nix
    ];

  sops.defaultSopsFile = "/etc/secrets/clusters/uff/uff.yaml";
}
