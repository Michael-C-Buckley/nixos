{config, ...}: {
  flake.modules.nixos.oxwm = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      config.flake.custom.hjemConfigs.oxwm
    ];

    environment.systemPackages = with pkgs; [
      # Utility
      arandr
      rofi
      redshift

      # Screenshotting
      maim
      xclip
    ];

    # Disable the default greetd setup I have in order to force the use of X11 and OXWM
    # Sadly necessary as I've not been able to yet figure out how to properly launch Xserver with greetd
    services.greetd.enable = lib.mkForce false;

    services = {
      libinput.enable = true;

      displayManager = {
        defaultSession = "oxwm";
        autoLogin = {
          enable = true;
          user = "michael";
        };
      };

      xserver = {
        enable = true;
        xkb.layout = "us";
        displayManager.lightdm.enable = true;

        windowManager.session = lib.singleton {
          name = "oxwm";
          start = ''
            export _JAVA_AWT_WM_NONREPARENTING=1
            ${lib.getExe pkgs.oxwm} &
            waitPID=$!
          '';
        };
      };
    };
  };
}
