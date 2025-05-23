{pkgs, ...}: {
  imports = [
    ./vscode.nix
  ];

  apps = {
    browsers.librewolf.enable = true;
    communication = {
      signal.enable = true;
      discord.enable = true;
      telegram.enable = true;
    };
  };

  appearance = {
    cursor = {
      manage = true;
      hyprtheme = "Nordzy-hyprcursors-white";
      xtheme = "Nordzy-cursors-white";
      size = 28;
      package = pkgs.nordzy-cursor-theme;
    };
    gtk = {
      manage = true;
      theme.name = "Materia-dark";
      theme.package = pkgs.materia-theme;
      iconTheme.name = "Gruvbox Dark";
      iconTheme.package = pkgs.gruvbox-dark-icons-gtk;
    };
  };
}
