{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  # My defaults for Nix-Serve
  services.nix-serve = {
    package = mkDefault pkgs.nix-serve-ng;
    openFirewall = mkDefault true;
    secretKeyFile = mkDefault "/etc/nix/nix-serve/secret-key.pem";
  };
}
