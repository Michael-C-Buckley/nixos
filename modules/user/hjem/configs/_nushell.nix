# WIP: Basic nushell config
{
  flake.modules.nixos.hjem-nushell = {
    hjem.users.michael.rum.programs.nushell = {
      enable = true;
      settings = {
        show_banner = false;
        buffer_editor = "nvim";
        history = {
          file_format = "sqlite";
          max_size = "1_000_000";
          sync_on_enter = true;
          isolation = true;
        };
      };
    };
  };
}
