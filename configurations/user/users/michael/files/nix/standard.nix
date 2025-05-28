{
  # Bash
  ".bashrc".source = ../bash/.bashrc;
  ".bash_profile".source = ../bash/.bash_profile;

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
  ".config/fish/conf.d/functions.fish".source = ../fish/functions.fish;

  # GnuPG
  ".config/pubkeys/michael1.asc".source = ../gnupg/michael1.asc;
  ".config/pubkeys/michael2.asc".source = ../gnupg/michael2.asc;
  ".gnupg/gpg.conf".source = ../gnupg/gpg.conf;
  ".gnupg/gpg-agent.conf".source = ../gnupg/gpg-agent.conf;
  ".gnupg/scdaemon.conf".source = ../gnupg/scdaemon.conf;

  # Ghostty
  ".config/ghostty/config".source = ../userfiles/ghostty;

  #Git
  ".gitconfig".source = ../userfiles/.gitconfig;

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
  ".config/waybar/config.jsonc".source = ../waybar/custom/config.jsonc;
  ".config/waybar/style.css".source = ../waybar/custom/style.css;
  ".config/waybar/scripts/powerdraw.sh".source = ../waybar/custom/powerdraw.sh;

  # X-server
  #".config/.Xresources".source = ../userfiles/Xresources;

  # Zsh
  ".zshrc".source = ../zsh/default.zshrc;
  ".config/zsh/geometry/myGeometry.zsh".source = ../zsh/myGeometry.zsh;
}
