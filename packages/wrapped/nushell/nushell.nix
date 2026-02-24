# My first attempt at Nushell, this wrapper is not going to be considered final or stable
# for quite a while likely
{
  config,
  lib,
  ...
}: let
  inherit
    (config.flake.wrappers)
    mkNushell
    mkNuConfig
    mkNuEnvConfig
    mkGitConfig
    mkGitSignersFile
    mkStarship
    ;
in {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    home =
      if lib.hasSuffix "darwin" system
      then "Users"
      else "home";
  in {
    packages.nushell = mkNushell {
      inherit pkgs;
      env = {
        NH_FLAKE = "/${home}/michael/nixos";
        NIXPKGS_ALLOW_UNFREE = "1";
        GIT_SIGNING_KEYS_FILE = mkGitSignersFile {inherit pkgs;};
        GIT_CONFIG_GLOBAL = mkGitConfig {inherit pkgs;};
      };
    };
  };
  flake.wrappers = {
    mkNuConfig = {
      pkgs,
      extraAliases ? {},
      extraConfig ? "",
    }: let
      inherit (config.flake.userModules.shellAliases) basic nu extra;
      mergedAliases = basic // extra // nu // extraAliases;
      aliases = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "alias ${k} = ${v}") mergedAliases);
    in
      pkgs.writeText "nu-config" (
        (builtins.readFile ./config.nu)
        + (builtins.readFile ./starship.nu)
        + ''
          source ${../resources/shells/key_script.nu}
          source $"($nu.cache-dir)/carapace.nu"
        ''
        + extraConfig
        + aliases
      );

    mkNuEnvConfig = {
      pkgs,
      env ? {},
      extraConfig ? "",
    }: let
      completions = ''
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
        mkdir $"($nu.cache-dir)"
        carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
      '';
      envAttrs =
        (lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "$env.${k} = ${builtins.toJSON v}") env
        ))
        + "\n";
    in
      pkgs.writeText "nu-env-config" (envAttrs + completions + extraConfig);

    mkNushell = {
      pkgs,
      env ? {},
      extraConfig ? "",
      extraAliases ? {},
      extraRuntimeInputs ? [],
    }: let
      buildInputs = with pkgs;
        [
          # Shell Utilities
          carapace
          carapace-bridge
          direnv
          nix-direnv
          # Command Line
          bat
          eza
          fd
          fzf
          jq
          ripgrep
          # VCS
          git
          delta
          tig
          lazygit
        ]
        ++ [(mkStarship {inherit pkgs;})]
        ++ extraRuntimeInputs;

      nuConfig = mkNuConfig {inherit pkgs extraAliases extraConfig;};
      nuEnvConfig = mkNuEnvConfig {inherit pkgs env;};
    in
      pkgs.symlinkJoin {
        name = "nu";
        paths = [pkgs.nushell];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/nu \
            --add-flags "--config ${nuConfig} --env-config ${nuEnvConfig}" \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
        passthru.shellPath = "/bin/nu";
      };
  };
}
