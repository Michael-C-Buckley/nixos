{
  flake.modules.nixos.network = {
    networking.hosts = {
      "192.168.48.1" = ["mt3" "mt3.michael.lan"];
      "192.168.48.2" = ["c9300" "c9300.michael.lan"];
      "192.168.48.3" = ["r8200" "r8200.michael.lan"];

      "192.168.48.20" = ["m1" "m1.michael.lan"];
      "192.168.63.10" = ["x570" "x570.michael.lan"];

      "192.168.63.5" = ["p520" "p520.michael.lan"];
      "192.168.49.5" = [
        "git.p520.michael.lan"
        "owi.p520.michael.lan"
      ];

      # 2.5GbE
      "192.168.61.145" = ["uff1s"];
      "192.168.61.146" = ["uff2s"];
      "192.168.61.147" = ["uff3s"];

      # Loopbacks
      "192.168.61.0" = ["uff" "uff.michael.lan"];
      "192.168.61.1" = ["uff1" "uff1.michael.lan"];
      "192.168.61.2" = ["uff2" "uff2.michael.lan"];
      "192.168.61.3" = ["uff3" "uff3.michael.lan"];
    };
  };
}
