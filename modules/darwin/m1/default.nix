# First draft for a nix-darwin config
{
  self,
  config,
  inputs,
  ...
}: let
  localPkgs = config.flake.packages.aarch64-darwin;
in {
  flake.modules.darwin.default = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = [
      inputs.nix-darwin.packages.aarch64-darwin.default

      # Adds my NVF under the nvf command
      (pkgs.writeShellApplication {
        name = "nvf";
        text = ''
          exec ${lib.getExe localPkgs.nvf} "$@"
        '';
      })

      # Standard edition for use with vscode
      pkgs.neovim
    ];

    # This is a Determinate system
    nix.enable = false;

    programs = {
      direnv.enable = true;
      fish.enable = true;
    };

    fonts.packages = with pkgs; [
      cascadia-code
    ];

    # Set Git commit hash for darwin-version.
    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 6;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
