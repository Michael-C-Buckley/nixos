{
  config,
  pkgs,
  ...
}: {
  users.users.shawn = {
    packages = config.packageSets.common;
    shell = pkgs.zsh;
  };
}
