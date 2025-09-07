{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  services.nix-serve = {
    package = pkgs.nix-serve-ng;
    openFirewall = mkDefault true;
    port = mkDefault 5000;
  };
}
