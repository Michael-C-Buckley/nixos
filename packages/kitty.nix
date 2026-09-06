{
  pkgs,
  kitty,
  extraConf ? "",
  fonts ? [ pkgs.lilex ],
  ...
}:
let
  font = pkgs.makeFontsConf { fontDirectories = fonts; };
  config = ./configs/kitty/kitty.conf;
  # My default, unless I override
  optionsFile = ''
    font_family family='Lilex Nerd Font' style=Medium
    font_size 11
  '';
in
pkgs.symlinkJoin {
  name = "kitty";
  paths = [ kitty ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  postBuild = ''
    ln -s ${config} $out/kitty.conf

    mkdir -p "$out/kitty.d/nix"
    printf '%s' ${pkgs.lib.escapeShellArg optionsFile} \
      > "$out/kitty.d/nix/98_nix_default.conf"

    printf '%s' ${pkgs.lib.escapeShellArg extraConf} \
      > "$out/kitty.d/nix/99_extra.conf"

    wrapProgram $out/bin/kitty \
      --set FONTCONFIG_FILE ${font} \
      --add-flags "--config $out/kitty.conf"
  '';
}
