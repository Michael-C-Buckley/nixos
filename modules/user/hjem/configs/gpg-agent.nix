{
  flake.hjemConfig.gpgAgent = {
    hjem.users.michael = {
      gnupg = {
        agent = {
          enable = true;
          allowLoopbackPinentry = true;
          enableSSHsupport = true;
          extraLines = ''
            card-timeout 1
          '';
        };
        scdaemon = {
          disable-ccid = true;
        };
      };
    };
  };
}
