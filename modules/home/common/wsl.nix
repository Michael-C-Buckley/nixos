{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.wsl = {
    pkgs,
    lib,
    ...
  }: let
    # WSL uses a different signing key standard
    git = flake.wrappers.mkGit {
      inherit pkgs;
      signingkey = "/home/michael/.ssh/id_ed25519_sk";
    };
  in {
    home.packages = [
      (lib.hiPrio git)
    ];
  };
}
