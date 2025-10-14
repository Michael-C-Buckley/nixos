{
  flake.modules.nixos.hjem-direnv = {
    hjem.users.michael.rum.programs.direnv = {
      enable = true;
      integrations = {
        fish.enable = true;
        nushell.enable = true;
      };
      settings = {
        log.level = "error";
        whitelist.prefix = ["/home/michael/nixos" "/etc/nixos" "/etc/nix/secrets/"];
      };
    };
  };
}
