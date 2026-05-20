{flake, ...}: {
  imports = with flake.nixosModules; [
    server-preset
    dnscrypt-proxy
    ntp
    wifi-home
  ];

  sops.defaultSopsFile = "/etc/secrets/clusters/uff/uff.yaml";
}
