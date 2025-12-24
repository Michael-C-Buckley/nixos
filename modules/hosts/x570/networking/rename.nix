# Statically rename all NICs to prevent issues
let
  mkLink = name: mac: ''
    [Match]
    MACAddress=${mac}

    [Link]
    Name=${name}
  '';
in {
  flake.modules.nixos.x570 = {config, ...}: {
    environment.etc = {
      "systemd/network/10-eno1.link".source = config.sops.templates.eno1.path;
      "systemd/network/10-eno2.link".source = config.sops.templates.eno2.path;
      "systemd/network/10-enx3.link".source = config.sops.templates.enx3.path;
      "systemd/network/10-enx4.link".source = config.sops.templates.enx4.path;
    };

    sops = {
      secrets = {
        "nic/eno1" = {};
        "nic/eno2" = {};
        "nic/enx3" = {};
        "nic/enx4" = {};
      };
      templates = {
        eno1.content = mkLink "eno1" config.sops.placeholder."nic/eno1";
        eno2.content = mkLink "eno2" config.sops.placeholder."nic/eno2";
        enx3.content = mkLink "enx3" config.sops.placeholder."nic/enx3";
        enx4.content = mkLink "enx4" config.sops.placeholder."nic/enx4";
      };
    };
  };
}
