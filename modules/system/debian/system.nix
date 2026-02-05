{
  flake.modules.systemManager.debian = {
    system-manager.allowAnyDistro = true;

    nixpkgs.hostPlatform = "x86_64-linux";

    environment.etc = {
      "resolv.conf".text = ''
        nameserver 1.1.1.1
        nameserver 9.9.9.9
      '';

      "wsl.conf".text = ''
        [boot]
        systemd=true

        [network]
        generateHosts=false
        generateResolvConf=false
        hostname=debian
      '';
    };
  };
}
