{config, ...}: let
  inherit (config) flake;

  # for Git
  extraConfig.user.signingkey = "/home/michael/.ssh/id_ed25519_sk";
in {
  flake.modules.homeManager.wsl = {
    pkgs,
    lib,
    ...
  }: let
    # WSL uses a different signing key standard
    git = flake.wrappers.mkGit {
      inherit pkgs extraConfig;
    };
  in {
    home = {
      files.".config/git/config".source = flake.wrappers.mkGitConfig {inherit pkgs extraConfig;};
      packages = [
        (lib.hiPrio git)
      ];
    };
  };
}
