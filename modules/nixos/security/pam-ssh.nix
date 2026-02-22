{
  flake.modules.nixos.pam-ssh = {config, ...}: let
    inherit (config.security) sudo doas;
  in {
    security.pam = {
      rssh.enable = true;
      services = {
        sudo.rssh = sudo.enable;
        doas.rssh = doas.enable;
      };
    };
  };
}
