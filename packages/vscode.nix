# I do use vscode occasionally, when I'm not using NVF (nix-based nvim distro) or Zed
# Since I do, I use the official Microsoft version and use their settings sync to push
# my various configs and extensions between machines, to include Windows ones
# I previously used various nix-managed solutions for it, but it was always a pain
{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    # Allow unfree and extend with the extensions overlay
    pkgs' = import inputs.nixpkgs {
      localSystem = pkgs.stdenv.hostPlatform;
      config.allowUnfree = true;
    };

    # These are placed in the path of the program
    wrappedInputs = with pkgs'; [
      neovim

      python313
      uv

      nil
      nixd
      sops

      go
      gopls
      delve
      go-tools
      golangci-lint
    ];
  in {
    packages.vscode = pkgs.symlinkJoin {
      name = "code";
      paths = [pkgs'.vscode];
      buildInputs = wrappedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/code \
        --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
      '';
    };
  };
}
