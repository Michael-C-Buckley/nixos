# This is an exceptions module where I'm pulling something from a previous nixpkgs due to issues
{inputs, ...}: {
  flake.modules.nixos.stable = {pkgs, ...}: let
    stablePkgs = import inputs.nixpkgs-stable {
      inherit (pkgs) system allowUnfree;
    };
  in {
    programs.ssh.package = stablePkgs.openssh;
  };
}
