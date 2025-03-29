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

  # Shell Common
  ".config/starship.toml".source = ../shells/starship.toml;
  ".config/shells/aliases.sh".source = ../shells/aliases.sh;
  ".config/shells/environment.sh".source = ../shells/environment.sh;

  # Nushell
  ".config/nushell/config.nu".source = ../nushell/config.nu;

  # Waybar
  ".config/waybar/config.jsonc".source = ../waybar/moon-purple/config.jsonc;
  ".config/waybar/style.css".source = ../waybar/moon-purple/style.css;

  # Zsh
  ".zshrc".source = ../zsh/default.zshrc;
  ".config/zsh/geometry/myGeometry.zsh".source = ../zsh/myGeometry.zsh;
}
