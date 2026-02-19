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
  signingKeys = ''
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICVdKrhTH1OxUE/164StP+Iu5sOGcGEmpTyNvarAUn69AAAABHNzaDo=
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDmeP5ouNAD/hWUMq6DsZzLQCtOIh8rvQghX/huztRc8AAAAEXNzaDptaWNoYWVsQHlrNTcz
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKAR+0i/+FR8pFkwiU7jubzaPrDJAhtX3qMpYrGVnVE/AAAAEXNzaDptaWNoYWVsQHlrOTAy
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHs226+TygXNbePufYVItfHQqTgAO8JChAigzEfQK4ftAAAAEXNzaDptaWNoYWVsQHlrMDcz
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJRDTnuE/pbhRwOkDyK4ZpRztJ7zYvN3cAHl+xCSGgYDAAAABHNzaDo=
    sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO7l+i5FouCyBe4stv0W9jGs/XBCy4VYioefx0S4ud3WAAAACnNzaDpnaXRodWI=
  '';

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
      signingkey = "/${home}/michael/.ssh/git_signing.pub";
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

    mkGitSignersFile = {
      pkgs,
      extraKeys ? '''',
    }:
      pkgs.writeText "git-allowed-signers" (signingKeys + extraKeys);
  };
}
