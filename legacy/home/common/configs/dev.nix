# Development tools for when not using wrapped packages like via WSL
{
  flake.modules.homeManager.dev = {pkgs, ...}: {
    home.packages = with pkgs; [
      nil
      nixd
      alejandra

      python3
      uv
      ruff

      rust-analyzer
      rustfmt
    ];
  };
}
