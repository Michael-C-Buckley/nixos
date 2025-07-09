# 1 has been temporarily moved to a separate location
_: {
  imports = [
    ./networking/routing.nix
    ./hardware.nix
  ];
  networking = {
    hostName = "sff";
    loopback.ipv4 = "192.168.78.140";
    hostId = "fb020cc1";
    firewall.enable = false;
  };

  presets.kubernetes.singleNode = true;
  # WIP: Add this to a kube option
  services.kubernetes.masterAddress = "192.168.65.106";

  system = {
    stateVersion = "25.11";
    preset = "server";
    impermanence.enable = true;
    boot.uuid = "DF19-0E9F";
  };
}
