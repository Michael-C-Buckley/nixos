{config, ...}: let
  inherit (config.flake.userModules.bash) bashrc bashProfile;
in {
  flake.hjemConfigs.bash = {
    hjem.users.michael = {
      files = {
        ".bashrc".text = bashrc;
        ".bash_profile".text = bashProfile;
      };
    };
  };
}
