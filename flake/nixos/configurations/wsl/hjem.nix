{lib, ...}: {
  hjem.users.michael = {
    environment.sessionVariables = {
      NH_FLAKE = lib.mkForce "/home/michael/flakes/wsl";
    };
  };
}
