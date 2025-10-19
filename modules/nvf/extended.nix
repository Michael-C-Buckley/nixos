{self, ...}: {
  flake.modules.nvf.extended = {
    imports = with self.modules.nvf; [
      python
      golang
    ];

    vim = {
      runner.run-nvim = {
        enable = true;
      };
    };
  };
}
