{
  flake.modules.nixos.t14 = {
    hjem.users.michael = {
      xdg.config.files."noctalia/settings" = {
        source = ./settings.json;
        type = "copy";
        permissions = "0644";
      };
    };
  };
}
