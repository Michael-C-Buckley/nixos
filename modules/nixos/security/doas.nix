{
  flake.modules.nixos.doas = {pkgs, ...}: {
    environment.systemPackages = [pkgs.doas-sudo-shim];

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
