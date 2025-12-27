{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.git = config.flake.wrappers.mkGit {inherit pkgs;};
  };

  flake.wrappers = {
    mkGit = {
      pkgs,
      pkg ? pkgs.git,
      extraConfig ? '''',
    }: let
      buildInputs = with pkgs; [
        tig
        delta
      ];

      cfg = pkgs.writeText "git-wrapped-config" (config.flake.wrappers.mkGitConfig {inherit extraConfig;});
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
    mkGitConfig = {extraConfig ? ''''}: import ./_config.nix {inherit extraConfig;};
  };
}
