{pkgs, ...}: {
  imports = [
    ./lazy.nix
  ];

  vim.startPlugins = with pkgs.vimPlugins; [
    transparent-nvim
  ];
}
