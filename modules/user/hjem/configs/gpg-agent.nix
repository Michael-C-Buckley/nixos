{
  flake.modules.nixos.hjem-gpgAgent = {
    hjem.users.michael = {
      gnupg.agent = {
        enable = true;
        allowLoopbackPinentry = true;
        enableSSHsupport = true;
      };
    };
  };
}
