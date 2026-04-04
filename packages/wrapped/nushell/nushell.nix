# My first attempt at Nushell, this wrapper is not going to be considered final or stable
# for quite a while likely
{
  config,
  lib,
  ...
}: let
  inherit
    (config.flake.custom.wrappers)
    mkNushell
    mkNuConfig
    mkNuEnvConfig
    mkGitConfig
    mkGitSignersFile
    mkStarship
    ;
  inherit (config.flake.custom.functions) printConfig;
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
  flake.custom.wrappers = {
    mkNuConfig = {
      pkgs,
      extraAliases ? {},
      extraConfig ? "",
    }: let
      inherit (config.flake.custom.userModules.shellAliases) basic nu extra;
      mergedAliases = basic // extra // nu // extraAliases;
      aliases = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "alias ${k} = ${v}") mergedAliases);
    in
      pkgs.writeText "nu-config" (
        (builtins.readFile ./config.nu)
        + (builtins.readFile ./starship.nu)
        + (builtins.readFile ./git.nu)
        + ''
          source ${config.flake.custom.userModules.nu.keyScript}
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
        $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
        mkdir $"($nu.cache-dir)"
        carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
        mkdir ('~/.config/nushell' | path expand)
        touch ('~/.config/nushell/host.nu' | path expand)
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
      runtimeEnv = pkgs.buildEnv {
        name = "nushell-runtime-env";
        pathsToLink = ["/bin"];

        paths = with pkgs;
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
      };

      cfg = mkNuConfig {inherit pkgs extraAliases extraConfig;};
      envCfg = mkNuEnvConfig {inherit pkgs env;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "nu-print-config";
      };

      printEnv = printConfig {
        inherit pkgs;
        name = "nu-print-env";
        cfg = envCfg;
      };
    in
      pkgs.symlinkJoin {
        name = "nu";
        paths = [pkgs.nushell];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out
          cp -r ${printEnv}/bin $out

          wrapProgram $out/bin/nu \
            --add-flags "--config ${cfg} --env-config ${envCfg}" \
            --prefix PATH : ${runtimeEnv}/bin
        '';
        passthru.shellPath = "/bin/nu";
      };
  };
}
