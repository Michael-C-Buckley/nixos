{config, ...}: {
  perSystem = {pkgs, ...}: {
    # A generic one with difftastic but no signing keys set
    packages.git = config.flake.wrappers.mkGit {inherit pkgs;};
  };

  flake.wrappers = {
    mkGit = {
      pkgs,
      pkg ? pkgs.git,
      extraConfig ? '''',
      gpgProgram ? null,
      signingKey ? null,
    }: let
      buildInputs = with pkgs; [
        tig
        delta
      ];

      cfg = pkgs.writeText "git-wrapped-config" (config.flake.wrappers.mkGitConfig {inherit extraConfig gpgProgram signingKey;});
    in
      pkgs.symlinkJoin {
        name = "git";
        paths = [pkg];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/git \
            --set GIT_CONFIG_GLOBAL ${cfg} \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };

    # For obtaining the config without the wrapped package
    # Useful for when git is changed in the path like in devshells
    mkGitConfig = {
      extraConfig ? '''',
      gpgProgram ? null,
      signingKey ? null,
    }:
      import ./_config.nix {inherit extraConfig signingKey gpgProgram;};
  };
}
