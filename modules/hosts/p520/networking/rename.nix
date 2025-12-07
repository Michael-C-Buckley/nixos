# Statically rename all NICs to prevent issues
let
  mkLink = name: mac: ''
    [Match]
    MACAddress=${mac}

    [Link]
    Name=${name}
  '';
in {
  flake.modules.nixos.p520 = {config, ...}: {
    environment.etc = {
      "systemd/network/10-eno1.link".source = config.sops.templates.eno1.path;
      "systemd/network/10-enx2.link".source = config.sops.templates.enx2.path;
      "systemd/network/10-enx3.link".source = config.sops.templates.enx3.path;
    };
    sops = {
      secrets = {
        "nic/eno1" = {};
        "nic/enx2" = {};
        "nic/enx3" = {};
      };
      templates = {
        eno1.content = mkLink "eno1" config.sops.placeholder."nic/eno1";
        enx2.content = mkLink "enx2" config.sops.placeholder."nic/enx2";
        enx3.content = mkLink "enx3" config.sops.placeholder."nic/enx3";
      };
    };
  };
}
