# Wrapped Kitty comes with my config and the font I normally use with it
{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.kitty = config.flake.custom.wrappers.mkKitty {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = {
    mkKittyConfig = {
      pkgs,
      extraBinds ? {},
      extraConfig ? {},
    }:
      import ./_config.nix {inherit pkgs extraConfig extraBinds;};
    mkKitty = {
      pkgs,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkKittyConfig {inherit pkgs extraBinds extraConfig;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "kitty-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "kitty";
        paths = [pkgs.kitty];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/kitty \
            --add-flags "-c ${cfg}" \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.cascadia-code];}}
        '';
      };
  };
}
