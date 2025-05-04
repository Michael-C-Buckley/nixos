{pkgs, inputs, system, ...}: {
  home.features.michael = {
    cursor = {
      hyprtheme = "Nordzy-hyprcursors-white";
      xtheme = "Nordzy-cursors-white";
      size = 28;
      package = pkgs.nordzy-cursor-theme;
    };
    gtk = {
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      iconTheme = {
        name = "Gruvbox Dark";
        package = pkgs.gruvbox-dark-icons-gtk;
      };
    };
  };
  users.users.michael.packages =
    [inputs.zen-browser.packages."${system}".default
    ];
}
