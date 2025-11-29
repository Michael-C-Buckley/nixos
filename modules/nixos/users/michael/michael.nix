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
        hashedPasswordFile = "/etc/secrets/michael/hashedPassword";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = "${shell}${shell.shellPath}";

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG6+24cgcdjouT4pDFaRa1rGq4DOeTj4KgoaNzF8Pbk2 cardno:28_821_573"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF8Vj/VOL+zH42HsUP/uB+yoyDCLQE1ips0owSpKTPeZ cardno:28_821_902"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInzc7JwVkBL5iWnZn4uBfjvD4ekhR4+pmSZot28QcAo openpgp:0xE468FB39"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5YIOvHA5dLyE/1RonI5qrGO3OZHGie3B3drvQdqXZc openpgp:0x3A6765A7"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAPJ+n6VsNExyFNl3n4itYdXcmvZj9qwOnO7m60bXX3+AAAABHNzaDo= yubikey@902"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIG7zLH1MC7ObakQipT8cJ8ZppseGn9MGdV/5Df8u+DIfAAAABHNzaDo= michael@573"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICVdKrhTH1OxUE/164StP+Iu5sOGcGEmpTyNvarAUn69AAAABHNzaDo= michael@t14 (#074)"
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILqRzNVovg805v52UxSRSZxZu0RwUOPlTA7eSHhkDpbrAAAABHNzaDo= michael@x570 (#870)"
          "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBB84j6XhMmxWezUYWqw0LMaVi5ZXdt7pxDOlwnLL1LLRRDpMVRiPp/Wz7+d7wTODz1tjATvXa8zv0MbW4pCa3Jx/3dY5oBtFjVnlkWcPcHrH4E3GFc45tos5xilimCItwQ== PIV:28_821_902"
          "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBGBNAbp1dKmqFQZHUKkfw5IQgHDIxLHyV56yNo0ZUYcToybBIyo6AHiqgLqnLdayREWncCq9oXQOYVpx1KRJO1InI/ugzYy7+u4gjJKc82yTvEoSN9VYaL2hFhv1evnbbg== PIV:28_821_573"
          "ecdsa-sha2-nistp384 AAAAE2VjZHNhLXNoYTItbmlzdHAzODQAAAAIbmlzdHAzODQAAABhBGaeBh5d/bJzWwln9f4/2DmFezJnsVznp+Bi2Ac5vm6dH2pt5jLZLV3RbZfXr1n5RAYX4cikXkKOwJYdBcYNT8h0wEsn9RA7AFEWLrpvqLhD6Mt0VN3a+hTnyVpo5Rdf6Q== PIV:33_928_074"
        ];
      };
    };
  };
}
