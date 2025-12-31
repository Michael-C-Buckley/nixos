{config, ...}: let
  # The usual standard location for my signing key
  defaultKey = "/home/michael/.ssh/id_ed25519_sk_rk_signing.pub";
in {
  perSystem = {pkgs, ...}: {
    packages.git = config.flake.wrappers.mkGit {inherit pkgs;};
  };

  flake.wrappers = {
    mkGit = {
      pkgs,
      pkg ? pkgs.git,
      extraConfig ? '''',
      signingKey ? defaultKey,
    }: let
      buildInputs = with pkgs; [
        tig
        delta
      ];

      cfg = pkgs.writeText "git-wrapped-config" (config.flake.wrappers.mkGitConfig {inherit extraConfig signingKey;});
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
      signingKey ? defaultKey,
      extraConfig ? '''',
    }:
      import ./_config.nix {inherit extraConfig signingKey;};
  };
}
