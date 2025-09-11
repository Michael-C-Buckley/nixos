{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
      # name = "Orchis-Dark";
      # package = pkgs.orchis-theme;
    };
    cursorTheme = {
      name = "Nordzy-cursors-white";
      package = pkgs.nordzy-cursor-theme;
    };
    iconTheme = {
      name = "Gruvbox Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };
}
