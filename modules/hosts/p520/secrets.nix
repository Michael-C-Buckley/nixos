{
  flake.modules.nixos.p520 = {
    sops = {
      defaultSopsFile = "/etc/secrets/hosts/p520/p520.yaml";
      secrets = {
        cachePrivateKey.mode = "0755"; # Public -- michaelcbuckley.dev-1:i6EiwHcLtrM6EAdpeymEWqlWs9p15HVTCjS+Cs/cgH0=
      };
    };
  };
}
