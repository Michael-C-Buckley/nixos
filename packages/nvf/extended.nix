# Additional language server for development machines
{
  imports = [
    ./languages/python.nix
    ./languages/go.nix
  ];

  vim = {
    runner.run-nvim = {
      enable = true;
    };
  };
}
