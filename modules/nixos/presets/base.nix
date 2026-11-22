{ inputs, lib, ... }:
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

  networking.nftables.enable = lib.mkDefault true;
  services.gnome.gcr-ssh-agent.enable = false;
  system.nixos-core.enable = true;
}
