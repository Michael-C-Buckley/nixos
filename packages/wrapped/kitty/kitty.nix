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
  in
    pkgs.symlinkJoin {
      name = "kitty";
      paths = [pkgs.kitty];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/kitty \
          --add-flags "-c ${import ./_config.nix {inherit pkgs extraConfig extraBinds;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
