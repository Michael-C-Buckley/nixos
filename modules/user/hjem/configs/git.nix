# Git is often often shadowed in the path by devshells and other
# tools, this ensures my config is available so that even unwrapped
# gits will work as expected in my environment
{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfig.git = {config, ...}: {
    hjem.users.michael.files = {
      ".config/git/config".text = flake.wrappers.mkGitConfig {
        inherit (config.hjem.users.michael.git) signingKey;
      };
    };
  };
}
