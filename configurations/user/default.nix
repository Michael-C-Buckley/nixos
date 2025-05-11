{
  config,
  pkgs,
  lib,
  ...
}: let
  # users = ["michael" "shawn"];
  userModules = [
    ./apps
    ./modules
  ];
in {
  imports = lib.flatten (map (m:
    import m {
      inherit config lib pkgs;
      user = "michael";
    })
  userModules);

  # Does not recognize the user param
  # imports = lib.flatten (map (user:
  #   map (m: import m ({inherit config lib pkgs user;}))
  #       userModules)
  #   users);
}
