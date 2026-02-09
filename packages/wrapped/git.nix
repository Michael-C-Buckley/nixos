# I primarily use wrappers for my git, but for the config file
# and not the fully wrapped binary
#
# WRAPPER PROBLEMS:
# It is not enough to just wrap the binary, because any nix shell
# environment will displace you git and you git falls back to files
#
# Ideally you have your base shell with the config
# This config is also references in my wrapped fish config
{
  config,
  lib,
  ...
}: let
  # My standard config, overwritten as needed on merging
  gitCfg = home: {
    advice.defaultBranchName = false;
    color = {
      diff = "auto";
      interactive = "auto";
      status = "auto";
      ui = true;
    };
    commit.gpgsign = true;
    gpg.format = "ssh";
    core = {
      editor = "nvim";
      pager = "delta";
    };
    interactive.diffFilter = "delta --color-only";
    delta = {
      side-by-side = true;
      line-numbers = true;
      navigate = true;
    };
    merge.conflictStyle = "zdiff3";
    http.postBuffer = 157286400;
    user = {
      name = "Michael Buckley";
      email = "michaelcbuckley@proton.me";
      signingkey = "/${home}/michael/.ssh/id_ed25519_sk_signing.pub";
    };
  };
in {
  perSystem = {pkgs, ...}: {
    packages.git = config.flake.wrappers.mkGit {inherit pkgs;};
  };

  flake.wrappers = {
    # The fully wrapped package is somewhat limited, as any nix shell
    # will take precedent over your installed config path
    mkGit = {
      pkgs,
      pkg ? pkgs.git,
      extraConfig ? {},
    }: let
      home =
        if lib.hasSuffix "darwin" pkgs.stdenv.hostPlatform.system
        then "Users"
        else "home";
      buildInputs = with pkgs; [
        tig
        delta
      ];
    in
      pkgs.symlinkJoin {
        name = "git";
        paths = [pkg];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/git \
            --set GIT_CONFIG_GLOBAL ${pkgs.writers.writeTOML "git-wrapped-config" (lib.recursiveUpdate (gitCfg home) extraConfig)} \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };

    # For obtaining the config without the wrapped package
    # I use this whenever I need the config without the package
    mkGitConfig = {
      pkgs,
      extraConfig ? {},
    }: let
      home =
        if lib.hasSuffix "darwin" pkgs.stdenv.hostPlatform.system
        then "Users"
        else "home";
    in
      pkgs.writers.writeTOML "git-wrapped-config" (lib.recursiveUpdate (gitCfg home) extraConfig);
  };
}
