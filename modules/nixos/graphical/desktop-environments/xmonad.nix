{
  flake.modules.nixos.xmonad = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      xmobar
      dmenu
    ];
    services = {
      picom.enable = true;
    };
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = hpkgs:
            with hpkgs; [
              xmonad
              xmonad-extras
              xmonad-contrib
            ];
        };
      };
    };
  };
}
