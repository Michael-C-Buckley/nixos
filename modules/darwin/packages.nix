{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.packages = {pkgs, ...}: let
    inherit (config.flake.packages.aarch64-darwin) nvf vscode ns;
  in {
    environment.systemPackages =
      [
        # Ensure we can rebuild
        inputs.nix-darwin.packages.aarch64-darwin.default
        ns
        nvf
        vscode
      ]
      ++ (with pkgs; [
        # Mac's builtin SSH does not support SK keys
        openssh
        gnupg
        orbstack
        obsidian
        tig
        lazygit
      ]);

    fonts.packages = with pkgs; [
      cascadia-code
    ];
  };
}
