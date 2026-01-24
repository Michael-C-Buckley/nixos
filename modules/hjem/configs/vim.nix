# A minimal vim setup for things like servers
{
  flake.hjemConfigs.vim = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.vim];

      xdg.config.files."vim/vimrc".text =
        # vimscript
        ''
          syntax on
          filetype on
          filetype plugin on
          filetype indent on

          colorscheme habamax

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
          set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
        '';
    };
  };
}
