{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nixos-core.nixosModules.default
    ../hjem
    ../users
    ../system/nix.nix
    ../packages/base.nix
    ../system/openssh.nix
    ../security/sudo.nix
    ../system/time.nix
    ../shell
  ];

  boot.initrd.systemd = {
    emergencyAccess = "$y$j9T$nLo0vU4Q0O5n0Co3nWLsB1$/3nIIizcrSTcnkw.28CTn6pvuhaoMmJNVMUW4Ulx0g5";
    packages = [ pkgs.busybox ];
  };
  networking.nftables.enable = lib.mkDefault true;
  services.gnome.gcr-ssh-agent.enable = false;
  system.nixos-core.enable = true;
}
