{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    kdePackages.breeze
    kdePackages.breeze.qt5
  ];
  security.pam.environment = {
    QT_QPA_PLATFORMTHEME.default = "qt5ct";
    QT_STYLE_OVERRIDE.default = "breeze";
  };
}
