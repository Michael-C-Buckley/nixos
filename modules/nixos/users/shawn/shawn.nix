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
    environment.etc."ssh/authorized_keys.d/shawn".source = config.sops.secrets.shawn_ssh_pubkeys.path;

    users = {
      powerUsers.members = ["shawn"];
      users.shawn = {
        uid = 2001;
        group = "users";
        initialHashedPassword = "$6$qqfYcXgaiZknCMEO$vQWbS.ojgq1Z278tlMxXuHXwwXIbvnuYifD7InXpvzdg.jLYcMoawE1GGtJzEVGJGn80PLfT1cMVMlcsaX3h5.";
        hashedPasswordFile = "/etc/secrets/users/shawn/hashedPassword";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";
      };
    };
  };
}
