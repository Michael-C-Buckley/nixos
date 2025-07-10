{
  # Bash
  ".bashrc".source = ../bash/bashrc;
  ".bash_profile".source = ../bash/bash_profile;

  # Direnv
  ".config/direnv/direnv.toml".source = ../userfiles/direnv.toml;

  # Environment
  ".config/environment.d/standard.conf".source = ../userfiles/standard.conf;
  ".local/share/applications/mimeapps.list".source = ../userfiles/mimeapps.list;
  ".config/mimeapps.list". source = ../userfiles/mimeapps.list;

  # Fastfetch
  ".config/fastfetch/config.jsonc".source = ../fastfetch/config.jsonc;

  # Fish
  ".config/fish/config.fish".source = ../fish/config.fish;
  ".config/fish/functions/functions.fish".source = ../fish/functions.fish;

  # GnuPG (Pubkeys)
  ".config/pubkeys/michael.asc".source = ../gnupg/michael.asc;

  # Ghostty
  ".config/ghostty/config".source = ../userfiles/ghostty;

  # Git
  ".gitconfig".source = ../userfiles/.gitconfig;

  # Kitty
  ".config/kitty/kitty-base.conf".source = ../kitty/kitty-base.conf;

  #Rofi
  ".config/rofi/config.rasi".source = ../rofi/config.rasi;

  # Shell Common
  ".config/starship.toml".source = ../shells/starship.toml;
  ".config/shells/aliases.sh".source = ../shells/aliases.sh;
  ".config/shells/environment.sh".source = ../shells/environment.sh;

  # Nushell
  ".config/nushell/config.nu".source = ../nushell/config.nu;

  # Vivaldi Browser
  ".config/vivaldi/custom/phi.css".source = ../vivaldi/phi.css;

  # Waybar
  ".config/waybar/config".source = ../waybar/custom/config;
  ".config/waybar/style.css".source = ../waybar/custom/style.css;

  # X-server
  #".config/.Xresources".source = ../userfiles/Xresources;

  # Vim
  ".vimrc".source = ../vim/.vimrc;

  # Zsh
  ".zshrc".source = ../zsh/default.zshrc;
  ".config/zsh/geometry/myGeometry.zsh".source = ../zsh/myGeometry.zsh;
}
