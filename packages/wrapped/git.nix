{config, ...}: let
  # My standard config, overwritten as needed on merging
  gitCfg = {
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
      signingkey = "/home/michael/.ssh/id_ed25519_sk.pub";
    };
  };
in {
  perSystem = {pkgs, lib, ...}: {
    packages.git = config.flake.wrappers.mkGit {inherit pkgs;};
  };

  flake.wrappers = {
    mkGit = {
      pkgs,
      pkg ? pkgs.git,
      extraConfig ? {},
    }: let
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
            --set GIT_CONFIG_GLOBAL ${pkgs.writers.writeTOML "git-wrapped-config" (pkgs.lib.recursiveUpdate gitCfg extraConfig)} \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };

    # For obtaining the config without the wrapped package
    # Useful for when git is changed in the path like in devshells
    mkGitConfig = {
      pkgs,
      extraConfig ? {},
    }:
      pkgs.writers.writeTOML "git-wrapped-config" (pkgs.lib.recursiveUpdate gitCfg extraConfig);
  };
}
