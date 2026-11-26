{ modules, pkgs, ... }: {
  imports = [ modules.polkit ];
  environment.systemPackages = (import ../../../packages/lists.nix pkgs).yubikey;
  services = {
    udev.packages = [
      pkgs.yubikey-personalization
      pkgs.ccid
    ];
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.local && subject.active &&
            (action.id == "org.debian.pcsc-lite.access_card" ||
             action.id == "org.debian.pcsc-lite.access_pcsc")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
  finit = {
    tmpfiles.rules = [ "d /run/pcscd 0755 root root - -" ];
    services.pcscd = {
      description = "Smart-card daemon for YubiKey PIV";
      command = "${pkgs.pcsclite}/bin/pcscd --foreground";
      # Without the CCID driver pcscd sees no USB smart-card readers.
      environment.PCSCLITE_HP_DROPDIR = "${pkgs.ccid}/pcsc/drivers";
      conditions = [ "task/tmpfiles-setup/success" ];
    };
  };
}
