{config, ...}: {
  perSystem = {pkgs, ...}: {
    # A generic one with difftastic but no signing keys set
    packages.git = config.flake.wrappers.mkGit {inherit pkgs;};
  };

  flake.wrappers.mkGit = {
    pkgs,
    pkg ? pkgs.git,
    extraConfig ? '''',
    gpgProgram ? null,
    signingKey ? null,
  }: let
    buildInputs = [pkgs.difftastic];
  in
    pkgs.symlinkJoin {
      name = "git";
      paths = [pkg];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/git \
          --set GIT_CONFIG_GLOBAL ${import ./_config.nix {inherit pkgs extraConfig signingKey gpgProgram;}} \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
