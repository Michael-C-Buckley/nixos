# My first attempt at Nushell, this wrapper is not going to be considered final or stable
# for quite a while likely
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.wrappers) mkNushell mkNuConfig mkNuEnvConfig mkGitConfig mkGitSignersFile;
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
      extraConfig ? '''',
    }:
      pkgs.writeText "nu-config" (
        (builtins.readFile ./config.nu)
        +
        # Add my SSH key detection script
        ''
          source ${../resources/shells/key_script.nu}
        ''
        + extraConfig
      );

    mkNuEnvConfig = {
      pkgs,
      env ? {},
    }:
      pkgs.writeText "nu-env-config" (lib.concatStringsSep "\n" (
        lib.mapAttrsToList (k: v: "$env.${k} = ${builtins.toJSON v}") env
      ));

    mkNushell = {
      pkgs,
      env ? {},
      extraConfig ? '''',
      extraRuntimeInputs ? [],
    }: let
      buildInputs = with pkgs;
        [
          bat
          direnv
          eza
          fd
          fzf
          jq
          nix-direnv
          git
          ripgrep
          delta
          tig
          lazygit
        ]
        ++ extraRuntimeInputs;
    in
      pkgs.symlinkJoin {
        name = "nu";
        paths = [pkgs.nushell];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/nu \
            --add-flags "--config ${mkNuConfig {inherit pkgs extraConfig;}} --env-config ${mkNuEnvConfig {inherit pkgs env;}}" \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
        passthru.shellPath = "/bin/nu";
      };
  };
}
