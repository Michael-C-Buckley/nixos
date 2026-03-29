# Wrapped Kitty comes with my config and the font I normally use with it
{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.kitty = config.flake.wrappers.mkKitty {
      inherit pkgs;
    };
  };

  flake.wrappers.mkKitty = {
    pkgs,
    extraConfig ? {},
    extraBinds ? {},
    extraRuntimeInputs ? [],
  }: let
    buildInputs = [pkgs.cascadia-code] ++ extraRuntimeInputs;
    cfg = import ./_config.nix {inherit pkgs extraConfig extraBinds;};

    printCfg = config.flake.functions.printConfig {
      inherit cfg pkgs;
      name = "kitty-print-config";
    };
  in
    pkgs.symlinkJoin {
      name = "kitty";
      paths = [pkgs.kitty];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        cp -r ${printCfg}/bin $out

        wrapProgram $out/bin/kitty \
          --add-flags "-c ${cfg}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
