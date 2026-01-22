{inputs, ...}: {
  flake.modules.nixos.oxwm = {pkgs, ...}: {
    environment.systemPackages = [pkgs.xorg.xinit];
    services = {
      libinput.enable = true;
      xserver = {
        xkb.layout = "us";
        enable = true;
        windowManager.oxwm = {
          enable = true;
          package = inputs.oxwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
      };
    };
  };
}
