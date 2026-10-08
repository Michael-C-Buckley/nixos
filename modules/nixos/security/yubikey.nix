{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    libfido2
    yubico-piv-tool
    libp11
    age-plugin-yubikey
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  programs.yubikey-touch-detector = {
    enable = true;
    libnotify = true;
    unixSocket = true;
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
