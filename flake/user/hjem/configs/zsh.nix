# Plugin configs are from Nezia:
# https://github.com/nezia1/flocon/blob/main/config/optional/programs/terminal/shell/zsh.nix
{pkgs, ...}: {
  hjem.users.michael.rum.programs.zsh = {
    enable = true;
    plugins = {
      nix-zsh-completions = {
        source = "${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
        completions = ["${pkgs.nix-zsh-completions}/share/zsh/site-functions"];
      };
      zsh-completions.completions = ["${pkgs.zsh-completions}/share/zsh/site-functions"];
      zsh-fzf-tab = {
        source = "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";
        config = ''
          source <(fzf --zsh)

          # use lsd for fzf preview
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd'
          zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd'
          # disable sort when completing `git checkout`
          zstyle ':completion:*:git-checkout:*' sort false
          # set descriptions format to enable group support
          # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
          zstyle ':completion:*:descriptions' format '[%d]'
          # set list-colors to enable filename colorizing
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
          zstyle ':completion:*' menu no
          # preview directory's content with eza when completing cd
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          # custom fzf flags
          # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
          zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
          # To make fzf-tab follow FZF_DEFAULT_OPTS.
          # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
          zstyle ':fzf-tab:*' use-fzf-default-opts yes
          # switch group using `<` and `>`
          zstyle ':fzf-tab:*' switch-group '<' '>'
        '';
      };
      zsh-autosuggestions = {
        source = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        config = ''
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=gray,underline"
        '';
      };
      zsh-syntax-highlighting = {
        source = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        config = ''
          typeset -gA ZSH_HIGHLIGHT_STYLES
          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
          ZSH_HIGHLIGHT_STYLES[default]=none
          ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
          ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
          ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
          ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
          ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
          ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
          ZSH_HIGHLIGHT_STYLES[path]=bold
          ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
          ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
          ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[command-substitution]=none
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[process-substitution]=none
          ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
          ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
          ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
          ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[assign]=none
          ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
          ZSH_HIGHLIGHT_STYLES[named-fd]=none
          ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
          ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
          ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
          ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
        '';
      };
    };
    initConfig = ''
      source "$HOME/.config/shells/environment.sh"
      source "$HOME/.config/shells/functions.sh"
      source "$HOME/.config/shells/posix.sh"
      source "$HOME/.config/shells/aliases.sh"
      alias nix="noglob nix"

      # -----------------------------
      # Zsh Options
      # -----------------------------

      # Enable common features
      setopt auto_cd           # Automatically `cd` into directories
      setopt auto_pushd        # Enable directory stack with `pushd`/`popd`
      setopt share_history     # Share command history across Zsh sessions
      setopt hist_ignore_dups  # Ignore duplicate commands in history
      setopt hist_ignore_space # Ignore commands that start with a space in history
      setopt extended_glob     # Enable advanced globbing

      # Customize history behavior
      HISTFILE="$HOME/.zsh_history"
      HISTSIZE=10000
      SAVEHIST=10000

      # -----------------------------
      # Plugins and Frameworks
      # -----------------------------

      if [ -f /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      fi

      if [ -f /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      fi

      # -----------------------------
      # Completion
      # -----------------------------

      # Load completion system
      autoload -Uz compinit
      compinit

      # Fuzzy search for completions
      zstyle ':completion:*' menu select
      zstyle ':completion:*:default' list-colors /'/'

      # -----------------------------
      # Miscellaneous
      # -----------------------------

      # Prevent duplicate prompt display
      export PROMPT_EOL_MARK=""

      # Enable vi-mode for the command line
      bindkey -v
    '';
  };
}
