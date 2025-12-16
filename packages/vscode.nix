# I do use vscode occasionally, when I'm not using NVF (nix-based nvim distro) or Zed
# Since I do, I use the official Microsoft version and use their settings sync to push
# my various configs and extensions between machines, to include Windows ones
# I previously used various nix-managed solutions for it, but it was always a pain
{inputs, ...}: {
  perSystem = {
    system,
    lib,
    ...
  }: let
    # Allow unfree since vscode needs it
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # These are placed in the path of the program
    wrappedInputs = with pkgs; [
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

    jail = inputs.jail.lib.init pkgs;
    inherit (jail.combinators) gui network readonly rw-bind noescape;
    homeBind = path: (rw-bind (noescape path) (noescape path));

    # These are my directories I use, you likely want to adjust this
    bwrapFeatures = [
      gui
      network
      (readonly "/nix/store")
      (homeBind "~/nixos") # where I keep my system flake
      (homeBind "~/projects") # The rest of where I usually keep projects
      (homeBind "~/.config/Code")
      (homeBind "~/.vscode")
    ];

    localPkg = pkgs.symlinkJoin {
      name = "code";
      paths = [pkgs.vscode];
      buildInputs = wrappedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/code \
        --prefix PATH : ${pkgs.lib.makeBinPath wrappedInputs}
      '';
    };
  in {
    packages.vscode =
      if (lib.hasSuffix "linux" system)
      then (jail "code" localPkg bwrapFeatures)
      else localPkg;
  };
}
