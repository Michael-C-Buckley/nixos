{
  flake.modules.nixos.oxwm = {pkgs, ...}: {
    environment.systemPackages = [pkgs.xorg.xinit];
    services.xserver = {
      libinput.enable = true;
      xkb.layout = "us";
      enable = true;
      windowManager.oxwm.enable = true;
    };
  };
}
