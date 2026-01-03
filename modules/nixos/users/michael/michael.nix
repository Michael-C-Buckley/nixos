{config, ...}: let
  inherit (config) flake;

  envars = {
    NH_FLAKE = "/home/michael/nixos";
  };
in {
  flake.modules.nixos.michael = {
    config,
    pkgs,
    ...
  }: let
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env =
        config.custom.shell.environmentVariables
        // config.hjem.users.michael.environment.sessionVariables
        // envars;
    };
  in {
    users = {
      powerUsers.members = ["michael"];
      users.michael = {
        hashedPasswordFile = "/etc/secrets/users/michael/hashedPassword";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";
        openssh.authorizedKeys.keys = [
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICVdKrhTH1OxUE/164StP+Iu5sOGcGEmpTyNvarAUn69AAAABHNzaDo="
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILqRzNVovg805v52UxSRSZxZu0RwUOPlTA7eSHhkDpbrAAAABHNzaDo="
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBDfIFxTCpYmNKivpDhn2YRPFHcL3QN4ztuimnA2o/+DAAAABHNzaDo="
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDmeP5ouNAD/hWUMq6DsZzLQCtOIh8rvQghX/huztRc8AAAAEXNzaDptaWNoYWVsQHlrNTcz"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPf4FlUmj1rIXYC80u1YtvYijLEC9HNsNoNNSli26yfiAAAAEXNzaDptaWNoYWVsQHlrODcw"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKAR+0i/+FR8pFkwiU7jubzaPrDJAhtX3qMpYrGVnVE/AAAAEXNzaDptaWNoYWVsQHlrOTAy"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHs226+TygXNbePufYVItfHQqTgAO8JChAigzEfQK4ftAAAAEXNzaDptaWNoYWVsQHlrMDcz"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAeSC5gh3pMr5v3p+/Dh3SMddk/n5Dr+srLS3OV3hEqOAAAABHNzaDo="
        ];
      };
    };
  };
}
