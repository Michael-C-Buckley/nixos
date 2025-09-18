{config, ...}: let
  inherit (config.hjem.users.michae.rum) programs;
in {
  hjem.users.michael.rum.programs.direnv = {
    enable = true;
    integrations = {
      fish.enable = programs.fish.enable;
      nushell.enable = programs.nushelle.enable;
      zsh.enable = programs.zsh.enable;
    };
    settings = {
      log.level = "error";
      whitelist.prefix = ["/home/michael/nixos" "/etc/nixos" "/etc/nix/secrets/"];
    };
  };
}
