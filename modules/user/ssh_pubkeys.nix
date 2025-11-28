# Not technically Hjem, but this is the easiest way I have
# to share between NixOS and Darwin
{
  flake.hjemConfig.ssh-pubkeys = {
    users.users.michael.openssh.authorizedKeys.keys = [
      "/etc/secrets/michael/ssh/gpg-573.pub"
      "/etc/secrets/michael/ssh/gpg-902.pub"
      "/etc/secrets/michael/ssh/gpg-074.pub"
      "/etc/secrets/michael/ssh/gpg-870.pub"
      "/etc/secrets/michael/ssh/sk-902.pub"
      "/etc/secrets/michael/ssh/sk-573.pub"
      "/etc/secrets/michael/ssh/sk-074.pub"
      "/etc/secrets/michael/ssh/sk-870.pub"
      "/etc/secrets/michael/ssh/piv-902.pub"
      "/etc/secrets/michael/ssh/piv-573.pub"
      "/etc/secrets/michael/ssh/piv-074.pub"
    ];
  };
}
