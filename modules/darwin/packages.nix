{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.packages = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;

    # iproute2 on mac and with an override for color
    iproute2 = pkgs.writeShellApplication {
      name = "ip";
      text = ''
        exec ${pkgs.iproute2mac}/bin/ip -c "$@"
      '';
    };
  in {
    environment.systemPackages = builtins.attrValues {
      inherit (inputs.nix-darwin.packages.${system}) default;
      inherit iproute2;
      inherit (config.flake.packages.${system}) helix nushell ns zeditor;
      inherit
        (pkgs)
        nh
        openssh
        age
        age-plugin-yubikey
        sops
        ;
    };

    fonts.packages = with pkgs; [
      cascadia-code
      # For Zed
      lilex
      ibm-plex
    ];
  };
}
