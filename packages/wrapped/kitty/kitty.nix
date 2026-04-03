# Wrapped Kitty comes with my config and the font I normally use with it
{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.kitty = config.flake.custom.wrappers.mkKitty {
      inherit pkgs;
    };
  };

  flake.custom.wrappers.mkKitty = {
    pkgs,
    extraConfig ? {},
    extraBinds ? {},
  }: let
    cfg = import ./_config.nix {inherit pkgs extraConfig extraBinds;};

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
}
