{config, ...}: let
  inherit (config.flake.custom.userModules.bash) bashrc bashProfile;
in {
  flake.custom.hjemConfigs.bash = {
    hjem.users.michael = {
      files = {
        ".bashrc".source = bashrc;
        ".bash_profile".text = bashProfile;
      };
    };
  };
}
