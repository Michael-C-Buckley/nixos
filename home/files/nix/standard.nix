{
  # Bash
  ".bashrc".source = ../bash/.bashrc;
  ".bash_profile".source = ../bash/.bash_profile;

  # Direnv
  ".config/direnv/direnv.toml".source = ../userfiles/direnv.toml;

  # Fish
  ".config/fish/config.fish".source = ../fish/config.fish;
  ".config/fish/conf.d/functions.fish".source = ../fish/functions.fish;

  # Ghostty
  ".config/ghostty/config".source = ../userfiles/ghostty;

  #Git
  ".gitconfig".source = ../userfiles/.gitconfig;

  #GTK
  ".config/gtk-3.0/settings.ini".source = ../userfiles/gtk.conf;
  ".config/gtk-4.0/settings.ini".source = ../userfiles/gtk.conf;

  # Shell Common
  ".config/starship.toml".source = ../shells/starship.toml;
  ".config/shells/aliases.sh".source = ../shells/aliases.sh;
  ".config/shells/environment.sh".source = ../shells/environment.sh;

  # Nushell
  ".config/nushell/config.nu".source = ../nushell/config.nu;

  # Vivaldi Browser
  ".config/vivaldi/custom/phi.css".source = ../vivaldi/phi.css;

  # Waybar
  ".config/waybar/config.jsonc".source = ../waybar/custom/config.jsonc;
  ".config/waybar/style.css".source = ../waybar/custom/style.css;
  ".config/waybar/scripts/powerdraw.sh".source = ../waybar/waybar-minimal/scripts/powerdraw.sh;

  # Zsh
  ".zshrc".source = ../zsh/default.zshrc;
  ".config/zsh/geometry/myGeometry.zsh".source = ../zsh/myGeometry.zsh;
}
