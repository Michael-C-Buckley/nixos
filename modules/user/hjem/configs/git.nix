# Git is often often shadowed in the path by devshells and other
# tools, this ensures my config is available so that even unwrapped
# gits will work as expected in my environment
{config, ...}: let
  inherit (config.flake.wrappers) mkGitConfig;
in {
  flake.hjemConfigs.git = {pkgs, ...}: {
    hjem.users.michael.files = {
      ".config/git/config".source = mkGitConfig {inherit pkgs;};
    };
  };
}
