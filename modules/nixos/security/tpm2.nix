{ pkgs, ... }:
let
  extraGroups = [ "tss" ];
in
{
  environment.systemPackages = with pkgs; [
    ssh-tpm-agent
    tpm2-tools
    age-plugin-tpm
  ];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  users.users = {
    michael = { inherit extraGroups; };
    shawn = { inherit extraGroups; };
  };
}
