{pkgs, ...}: {
  imports = [
    ./vscode.nix
  ];

  apps.michael = {
    browsers.librewolf.enable = true;
    communication = {
      signal.enable = true;
      discord.enable = true;
      telegram.enable = true;
    };
  };

  home.features.michael = {
    cursor = {
      hyprtheme = "Nordzy-hyprcursors-white";
      xtheme = "Nordzy-cursors-white";
      size = 28;
      package = pkgs.nordzy-cursor-theme;
    };
    gtk = {
      theme.name = "Materia-dark";
      theme.package = pkgs.materia-theme;
      iconTheme.name = "Gruvbox Dark";
      iconTheme.package = pkgs.gruvbox-dark-icons-gtk;
    };
  };
}
