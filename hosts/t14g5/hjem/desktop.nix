{
  imports = [
    ./umbriel.nix
    ./kanshi.nix
  ];

  programs.hyprland.extraLuaFiles.personal.content = ./hyprland.lua;
}
