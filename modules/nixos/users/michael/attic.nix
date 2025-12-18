# An attempt at during runtime decryption
# The secrets are available via secrets deployment
{
  flake.modules.nixos.michael-attic = {
    pkgs,
    lib,
    ...
  }: let
    attic_login = {
      host,
      url,
    }:
      pkgs.writeShellApplication {
        name = "attic-${host}";
        text = ''
          TOKEN=$(${lib.getExe pkgs.sops} -d --extract '["attic_${host}"]' /etc/secrets/users/michael/secrets.yaml)
          exec ${lib.getExe pkgs.attic-client} login ${host} ${url} "$TOKEN"

        '';
      };

    attic_o1 = attic_login {
      host = "o1";
      url = "https://attic.groovyreserve.com";
    };
    attic_b550 = attic_login {
      host = "b550";
      url = "http://b550:3080";
    };
  in {
    users.users.michael.packages = [
      attic_o1
      attic_b550
    ];
  };
}
