{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # WIP: Add keys to Secrets
  services.nix-serve = {
    package = mkDefault pkgs.nix-serve-ng;
    openFirewall = mkDefault true;
    secretKeyFile = mkDefault "/etc/nix/nix-serve/secret-key.pem";
  };
}
