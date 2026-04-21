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
  inherit (config.flake.custom.wrappers) mkGit;
  signingKeys = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICVdKrhTH1OxUE/164StP+Iu5sOGcGEmpTyNvarAUn69AAAABHNzaDo=
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDmeP5ouNAD/hWUMq6DsZzLQCtOIh8rvQghX/huztRc8AAAAEXNzaDptaWNoYWVsQHlrNTcz
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKAR+0i/+FR8pFkwiU7jubzaPrDJAhtX3qMpYrGVnVE/AAAAEXNzaDptaWNoYWVsQHlrOTAy
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHs226+TygXNbePufYVItfHQqTgAO8JChAigzEfQK4ftAAAAEXNzaDptaWNoYWVsQHlrMDcz
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJRDTnuE/pbhRwOkDyK4ZpRztJ7zYvN3cAHl+xCSGgYDAAAABHNzaDo=
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO7l+i5FouCyBe4stv0W9jGs/XBCy4VYioefx0S4ud3WAAAACnNzaDpnaXRodWI=
    ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKwRoyE6eCR6RAiAnLACmi1RCi9cDVoFwoQZsf1t9NnHVWTG86+Gbln5Yeg8v3groM6MMgwtKLddbUyp1W9JkJ8=
    ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKCUs11g5Art9eoGCTw9ZHI8NAvCrkmQYHHmG3vivb+aUDwasx59AC8ElqP06QBlxKfyZ8CMfdgbTWr2aj8a6uU=
  '';

  # My standard config, overwritten as needed on merging
  gitCfg = {
    home,
    username ? "michael",
  }: {
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
      signingkey = "/${home}/${username}/.ssh/git_signing.pub";
    };
  };
in {
  perSystem = {pkgs, ...}: {
    packages.git = mkGit {inherit pkgs;};
  };

  flake.custom.wrappers = {
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
      runtimeEnv = pkgs.buildEnv {
        name = "git-runtime-env";
        pathsToLink = ["/bin"];
        paths = with pkgs; [
          tig
          delta
        ];
      };
    in
      pkgs.symlinkJoin {
        name = "git";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/git \
            --set GIT_CONFIG_GLOBAL ${pkgs.writers.writeTOML "git-wrapped-config" (lib.recursiveUpdate (gitCfg {inherit home;}) extraConfig)} \
            --prefix PATH : ${runtimeEnv}/bin
        '';
      };

    # For obtaining the config without the wrapped package
    # I use this whenever I need the config without the package
    mkGitConfig = {
      pkgs,
      extraConfig ? {},
      username ? "michael",
    }: let
      home =
        if lib.hasSuffix "darwin" pkgs.stdenv.hostPlatform.system
        then "Users"
        else "home";
    in
      pkgs.writers.writeTOML "git-wrapped-config" (lib.recursiveUpdate (gitCfg {inherit home username;}) extraConfig);

    mkGitSignersFile = {
      pkgs,
      extraKeys ? '''',
    }:
      pkgs.writeText "git-allowed-signers" (signingKeys + extraKeys);
  };
}
