# WIP: Basic nushell config
{
  flake.modules.nixos.hjem-nushell = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.nushell];

      # WIP: Mix in aliases
      xdg.config.files = {
        "nushell/config.nu" = {
          enable = true;
          text = ''
            $env.config = {
              show_banner: false
              buffer_editor: nvim
              edit_mode: vi

              completions: {
                case_sensitive: false
                quick: true
                partial: true
              }
              history: {
                max_size: 10000
                sync_on_enter: true
                file_format: "plaintext"
              }
              cursor_shape: {
                vi_insert: line
                vi_normal: block
              }
            }
          '';
        };
      };
    };
  };
}
