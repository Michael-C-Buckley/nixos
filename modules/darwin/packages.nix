{
  config,
  inputs,
  ...
}: {
  flake.modules.darwin.packages = {pkgs, ...}: let
    inherit (config.flake.packages.aarch64-darwin) fish starship nvf vscode;
  in {
    environment.systemPackages = [
      # Ensure we can rebuild
      inputs.nix-darwin.packages.aarch64-darwin.default

      # TODO: Check out the `programs.fish` options in nix-darwin
      fish
      starship
      nvf
      vscode

      # Mac's builtin SSH does not support SK keys
      pkgs.openssh
    ];

    font.packages = with pkgs; [
      cascadia-code
    ];
  };
}
