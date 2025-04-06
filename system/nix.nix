{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        # "http://192.168.48.9:5000" # X570 experimental cache
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://microvm.cachix.org"
        "https://cosmic.cachix.org/"
        "https://wfetch.cachix.org"
        "https://cache.lix.systems"
        "https://cache.thalheim.io"
      ];
      trusted-public-keys = [
        # "x570-cache:0ok3K6YU/4QGbHWBZlg8SE4nAgxmG2mKd9kDT38ctDM=" # X570 experimental cache
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "wfetch.cachix.org-1:lFMD3l0uT/M4+WwqUXpmPAm2kvEH5xFGeIld1av0kus"
        "cache.lix.systems-1:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc="
      ];
      trusted-users = [
        "@wheel"
        "nix-ssh"
      ];
    };
  };
}
