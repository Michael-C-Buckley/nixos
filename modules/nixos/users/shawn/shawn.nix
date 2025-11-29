{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.shawn = {
    config,
    pkgs,
    ...
  }: let
    shell = flake.wrappers.mkFish {
      inherit pkgs;
      env = config.custom.shell.environmentVariables;
    };
  in {
    users = {
      powerUsers.members = ["shawn"];
      users.shawn = {
        hashedPasswordFile = "/etc/secrets/shawn/hashedPassword";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDD9yjfz5AWFHX/R63OFXI6xw72Mu8k4+Iw6JKydjx0/a0Fspwa/gRSxv6UwQDMkJhv4p7PSR72WV9aMsFvDpgoyvPoU985zWDa0zQ+wXOmlZ6oaczvmFkknWaCxMWwLorSGqRt0xecAwGuc6EiPq18pZ8tsedZR0fWoN5L0+qe+ptFn5JaSEkwFflB2Kq69d+U+gfsR5KCf8O0p+X0Sy84jqbMMS37riIN9eHyNhNEDQCnzyK1yltCXvHaQoAEhMpd7F+267ThSqud3mQJH7NEzkw5OEpojOZPAPwOE3bt7MfSOscIRAyBQJEuymoLdKLyZXpo32QALOr0/5k7q5Veh0AZaE5NoYBdb07p0+qks3MRHQiyN39mTkpOmQhQTTID6ItPwQvCzXzGDL461tl2BnrERFSoWPkyLlWIvifyIyOgH38Zc9VtRYYSPpsrkuPWz9X7IVwbQPsB5XJ+eAsL5dB3fMoOca8nJ1Q8FcVDzRS95owlRhYkQ9E+tw2rGHs= shawn@t14sg3"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM639dgICX0wEOGtt27xeFGqveaUaF5G/nTe4Kyh3kQx openpgp:0xF8CB10D3"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoquX2xKvTXNV5Ds5p4upThgMbVjruq9ZoTp7mkZHmV openpgp:0x96181E6C"
        ];
      };
    };
  };
}
