{
  flake.modules.nixos.pam-ssh = {
    security = {
      pam = {
        rssh.enable = true;
        services.sudo = {
          rssh = true;
        };
      };
    };
  };
}
