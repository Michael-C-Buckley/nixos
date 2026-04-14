{
  flake.modules.nixos.t14 = {config, ...}: {
    hjem.users.${config.custom.hjem.username} = {
      xdg.config.files."noctalia/settings" = {
        source = ./settings.json;
        type = "copy";
        permissions = "0644";
      };
    };
  };
}
