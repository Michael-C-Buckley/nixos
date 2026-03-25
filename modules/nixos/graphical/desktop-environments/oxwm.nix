{
  config,
  inputs,
  ...
}: {
  flake.modules.nixos.oxwm = {
    pkgs,
    lib,
    ...
  }: let
    inherit (inputs.oxwm.packages.${pkgs.stdenv.hostPlatform.system}) oxwm;
  in {
    imports = [
      config.flake.hjemConfigs.oxwm
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

        windowManager = {
          oxwm = {
            enable = true;
            package = oxwm;
          };
          session = lib.singleton {
            name = "oxwm";
            start = ''
              export _JAVA_AWT_WM_NONREPARENTING=1
              ${lib.getExe oxwm} &
              waitPID=$!
            '';
          };
        };
      };
    };
  };
}
