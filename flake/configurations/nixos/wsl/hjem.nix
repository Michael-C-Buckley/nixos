{
  lib,
  self',
  pkgs,
  ...
}: let
  inherit (lib) hiPrio;
  inherit (pkgs) devenv socat;
in {
  hjem.users.michael = {
    packageList = [
      devenv
      socat
      (hiPrio self'.packages.nvf)
      (import ./packages/relay.nix {inherit pkgs;}) # USBIP will not work so I'm instead forwarding my agents
    ];
    programs = {
      custom.ns.enable = true;
      librewolf.enable = true;
    };
  };
}
