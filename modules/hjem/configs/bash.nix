{config, ...}: let
  inherit (config.flake.userModules.bash) bashrc bashProfile;
in {
  flake.hjemConfigs.bash = {
    hjem.users.michael = {
      files = {
        ".bashrc".source = bashrc;
        ".bash_profile".text = bashProfile;
      };
    };
  };
}
