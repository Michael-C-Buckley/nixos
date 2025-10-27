{
  flake.modules.nixos.hjem-gpg = {
    hjem.users.michael = {
      gnupg = {
        agent = {
          allowLoopbackPinentry = true;
          enableSSHsupport = true;
          extraLines = ''
            card-timeout 1
          '';
        };
        scdaemon = {
          #extraLines = ''pcsc-driver'';
          disable-ccid = true;
        };
      };
    };
  };
}
