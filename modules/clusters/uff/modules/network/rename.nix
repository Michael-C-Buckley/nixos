let
  mkLink = name: mac: ''
    [Match]
    MACAddress=${mac}

    [Link]
    Name=${name}
  '';
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (config.networking) hostName;
  in {
    environment.etc = {
      "systemd/network/10-eno1.link".source = config.sops.templates.eno1.path;
      "systemd/network/10-enu2.link".source = config.sops.templates.enu2.path;
      "systemd/network/10-wlan1.link".source = config.sops.templates.wlan1.path;
    };
    sops = {
      secrets = {
        "nic/${hostName}/eno1" = {};
        "nic/${hostName}/enu2" = {};
        "nic/${hostName}/wlan1" = {};
      };
      templates = {
        eno1.content = mkLink "eno1" config.sops.placeholder."nic/${hostName}/eno1";
        enu2.content = mkLink "enu2" config.sops.placeholder."nic/${hostName}/enu2";
        wlan1.content = mkLink "wlan1" config.sops.placeholder."nic/${hostName}/wlan1";
      };
    };
  };
}
