{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.packages = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) ns helix ghostty zeditor;
  in {
    environment.systemPackages =
      [
        # Ensure we can rebuild
        inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}.default
        ghostty
        zeditor
        ns
        helix

        # iproute2 on mac and with an override for color
        (pkgs.writeShellApplication {
          name = "ip";
          text = ''
            exec ${pkgs.iproute2mac}/bin/ip -c "$@"
          '';
        })
      ]
      ++ (with pkgs; [
        nh
        openssh # Mac's builtin SSH does not support SK keys
        age
        age-plugin-yubikey
        sops
        orbstack
        obsidian
      ]);

    fonts.packages = with pkgs; [
      cascadia-code
    ];
  };
}
