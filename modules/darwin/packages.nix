{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.packages = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) ns helix;
  in {
    environment.systemPackages =
      [
        # Ensure we can rebuild
        inputs.nix-darwin.packages.${pkgs.stdenv.hostPlatform.system}.default
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
        openssh # Mac's builtin SSH does not support SK keys
        orbstack
        obsidian
      ]);

    fonts.packages = with pkgs; [
      cascadia-code
    ];
  };
}
