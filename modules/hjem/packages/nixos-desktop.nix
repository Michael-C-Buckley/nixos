{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  packages = [
    # Local Overlay
    pkgs.localGram

    inputs.hermes.packages.${system}.desktop
  ];
}
