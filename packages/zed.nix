# Just a simple way to put some tools in the Zed path
# This also bwraps the linux variant
{config, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    zedInputs = with pkgs; [
      # Nix
      alejandra
      nil
      nixd
      statix

      # Go
      go
      gopls
      gofumpt

      # Python
      python3
      ruff
      pyrefly
      pyright
      basedpyright

      # Yaml
      yaml-language-server
    ];

    localPkg = pkgs.symlinkJoin {
      name = "zeditor";
      paths = [pkgs.zed-editor];
      buildInputs = zedInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "zeditor";
      postBuild = ''
        wrapProgram $out/bin/zeditor \
        --prefix PATH : ${pkgs.lib.makeBinPath zedInputs}
      '';
    };

    jail = (import "${config.flake.npins.jail}/lib").init pkgs;
    inherit (jail.combinators) gui gpu readonly rw-bind noescape;
    homeBind = path: (rw-bind (noescape path) (noescape path));

    # These are my directories I use, you likely want to adjust this
    bwrapFeatures = [
      gui
      gpu
      (readonly "/nix/store")
      (homeBind "~/nixos") # where I keep my system flake
      (homeBind "~/projects") # The rest of where I usually keep projects
      (homeBind "~/.config/zed")
      (homeBind "~/.cache/zed")
      (homeBind "~/.local/share/zed")
    ];
  in {
    packages =
      {
        zeditor = localPkg;
      }
      // lib.optionalAttrs (lib.hasSuffix "linux" system) {
        zeditor-jailed = jail "zeditor" localPkg bwrapFeatures;
      };
  };
}
