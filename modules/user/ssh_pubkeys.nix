# Not technically Hjem, but this is the easiest way I have
# to share between NixOS and Darwin
{
  flake.hjemConfig.ssh-pubkeys = {
    users.users = {
      michael.openssh.authorizedKeys.keys = [
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
      # TODO: Move to own module
      shawn.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDD9yjfz5AWFHX/R63OFXI6xw72Mu8k4+Iw6JKydjx0/a0Fspwa/gRSxv6UwQDMkJhv4p7PSR72WV9aMsFvDpgoyvPoU985zWDa0zQ+wXOmlZ6oaczvmFkknWaCxMWwLorSGqRt0xecAwGuc6EiPq18pZ8tsedZR0fWoN5L0+qe+ptFn5JaSEkwFflB2Kq69d+U+gfsR5KCf8O0p+X0Sy84jqbMMS37riIN9eHyNhNEDQCnzyK1yltCXvHaQoAEhMpd7F+267ThSqud3mQJH7NEzkw5OEpojOZPAPwOE3bt7MfSOscIRAyBQJEuymoLdKLyZXpo32QALOr0/5k7q5Veh0AZaE5NoYBdb07p0+qks3MRHQiyN39mTkpOmQhQTTID6ItPwQvCzXzGDL461tl2BnrERFSoWPkyLlWIvifyIyOgH38Zc9VtRYYSPpsrkuPWz9X7IVwbQPsB5XJ+eAsL5dB3fMoOca8nJ1Q8FcVDzRS95owlRhYkQ9E+tw2rGHs= shawn@t14sg3"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM639dgICX0wEOGtt27xeFGqveaUaF5G/nTe4Kyh3kQx openpgp:0xF8CB10D3"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoquX2xKvTXNV5Ds5p4upThgMbVjruq9ZoTp7mkZHmV openpgp:0x96181E6C"
      ];
    };
  };
}
