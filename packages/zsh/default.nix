{ inputs, pkgs }:
let
  tools = with pkgs; [
    starship
    zoxide
    eza
    bat
    fzf
  ];

  # zshrc's `plug owner/repo [file]` sources $ZSH_PLUGIN_DIR/<repo>/<file>, so
  # each entry is named after its upstream repository.
  mkPlugins =
    fzfTab:
    pkgs.linkFarm "zsh-plugins" {
      inherit (inputs) zsh-git-tab zsh-transient-prompt fast-abbr-highlighting;
      fzf-tab = fzfTab;
      zsh-abbr = "${pkgs.zsh-abbr}/share/zsh/zsh-abbr";
      zsh-autosuggestions = "${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions";
      fast-syntax-highlighting = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
    };

  config = pkgs.linkFarm "zsh-config" {
    ".zshenv" =
      pkgs.writeText "wrapped-zshenv"
        # bash
        ''
          _zsh_startup_dir=$ZDOTDIR
          source ${./configs/zshenv}
          ZDOTDIR=$_zsh_startup_dir
          unset _zsh_startup_dir
          typeset +x ZDOTDIR ZSH_PLUGIN_DIR
          export PATH="${pkgs.lib.makeBinPath tools}:$PATH"
          # Let login shells read the system zprofile before opting out of the system zshrc.
          [[ -o login ]] || unsetopt GLOBAL_RCS
        '';

    ".zprofile" =
      pkgs.writeText "wrapped-zprofile"
        # bash
        ''
          unsetopt GLOBAL_RCS
          source ${./configs/zprofile}
        '';

    ".zshrc" = ./configs/zshrc;
  };
in
pkgs.symlinkJoin {
  name = "zsh";
  paths = [ pkgs.zsh ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
    wrapProgram "$out/bin/zsh" \
      --set ZDOTDIR ${config} \
      --set STARSHIP_CONFIG ${./configs/starship.toml} \
      --set-default ZSH_PLUGIN_DIR ${mkPlugins "${pkgs.zsh-fzf-tab}/share/fzf-tab"}
  '';
  meta.mainProgram = "zsh";
  passthru = {
    inherit (pkgs.zsh) shellPath;
    # Host Zsh versions can differ from the one used to compile the native fzf-tab module.
    plugins = mkPlugins pkgs.zsh-fzf-tab.src;
  };
}
