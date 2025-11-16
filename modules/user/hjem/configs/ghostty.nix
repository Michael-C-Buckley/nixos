{
  flake.hjemConfig.ghostty = {lib, ...}: {
    hjem.users.michael.rum.programs.ghostty = {
      enable = true;
      settings = {
        theme = "Wombat";
        background = "#000000";
        font-size = "11";
        font-family = "Cascadia Code NF";

        background-opacity = lib.mkDefault "0.5";
        cursor-opacity = "0.6";
        cursor-color = "#44A3A3";

        window-theme = "system";
        window-decoration = "false";
      };
    };
  };
}
