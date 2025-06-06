{lib, ...}: {
  imports = [
    ./routing.nix
  ];

  # Use local DNS instead
  services.resolved.enable = lib.mkForce false;

  networking = {
    hostName = "x370";
    ospf.enable = true;
    hostId = "726afe29";
  };
}
