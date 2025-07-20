{
  config,
  pkgs,
  ...
}: {
  imports = [./impermanence.nix];

  users.users.shawn = {
    packages = config.packageSets.common;
    shell = pkgs.zsh;
  };
}
