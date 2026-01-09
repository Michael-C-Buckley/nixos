# Settings shared among physical devices located at home
{
  flake.modules.nixos.homelabPreset = {
    # Prefer local caches
    nix.settings = {
      substituters = [];
    };
  };
}
