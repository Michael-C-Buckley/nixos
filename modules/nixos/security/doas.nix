{
  flake.modules.nixos.doas = {
    environment.shellAliases.sudo = "doas";

    security = {
      sudo.enable = false;

      doas = {
        enable = true;
        extraRules = [
          {
            users = ["michael" "shawn"];
            keepEnv = true;
          }
        ];
      };
    };
  };
}
