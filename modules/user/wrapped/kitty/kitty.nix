{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.kitty = config.flake.wrappers.mkKitty {
      inherit pkgs;
    };
  };

  flake.wrappers.mkKitty = {
    pkgs,
    extraConfig ? "",
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
          --add-flags "-c ${import ./_config.nix {inherit pkgs extraConfig;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
