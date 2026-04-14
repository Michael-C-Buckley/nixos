{config, ...}: let
  inherit (config.flake.custom.userModules.bash) bashrc bashProfile;
in {
  flake.custom.hjemConfigs.bash = {config, ...}: {
    hjem.users.${config.custom.hjem.username} = {
      files = {
        ".bashrc".source = bashrc;
        ".bash_profile".text = bashProfile;
      };
    };
  };
}
