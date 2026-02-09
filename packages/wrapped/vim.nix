# My simple but cozy vim configuration for lightweight systems
# like servers and whatnot
{
  perSystem = {pkgs, ...}: let
    inherit (pkgs.vimPlugins) starrynight;
    cfg = pkgs.writeText "vimrc" ''
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      set runtimepath+=${starrynight}
      colorscheme starrynight

      set number
      set relativenumber
      set backspace=indent,eol,start
      set nocompatible

      set cursorline

      set autoindent
      set smartindent
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4

      set hlsearch
      set incsearch

      set ignorecase
      set smartcase

      set ruler
      set showcmd

      set mouse=a

      " Enable auto completion menu after pressing TAB.
      set wildmenu
      set wildmode=list:longest
      set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'';
  in {
    packages.vim = pkgs.symlinkJoin {
      name = "vim";
      paths = [pkgs.vim];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/vim \
          --set XDG_CONFIG_DIRS ${starrynight} \
          --set VIMINIT "source ${cfg}"
      '';
    };
  };
}
