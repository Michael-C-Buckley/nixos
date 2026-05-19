{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    libfido2
    yubikey-personalization
    yubico-piv-tool
    libp11
    age-plugin-yubikey
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
  };

  # https://github.com/NixOS/nixpkgs/issues/290926
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_card") {
        return polkit.Result.YES;
      }
    });

    polkit.addRule(function(action, subject) {
      if (action.id == "org.debian.pcsc-lite.access_pcsc") {
        return polkit.Result.YES;
      }
    });
  '';
}
