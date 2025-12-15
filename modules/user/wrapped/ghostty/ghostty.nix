{config, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    # Separate logic is needed for linux or mac
    # One goes to linux; Two goes to Mac
    # I have a few things different on the MacOS side
    separate = one: two:
      if (lib.hasSuffix "linux" system)
      then one
      else two;
    pkg = separate pkgs.ghostty config.flake.packages.${system}.ghostty-dmg;
    extraConfig = separate "" ''
      command = fish
      window-decoration = false
    '';
    extraRuntimeInputs = separate [] [config.flake.packages.${system}.fish];
  in {
    packages = {
      ghostty = config.flake.wrappers.mkGhostty {
        inherit pkg pkgs extraConfig extraRuntimeInputs;
      };
    };
  };

  flake.wrappers.mkGhostty = {
    pkgs,
    pkg ? pkgs.ghostty,
    extraConfig ? "",
    extraRuntimeInputs ? [],
  }: let
    buildInputs = [pkgs.cascadia-code] ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "ghostty";
      paths = [pkg];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/ghostty \
          --add-flags "--config-file=${import ./_config.nix {inherit pkgs extraConfig;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
