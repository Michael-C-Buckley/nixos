{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    allInputs = with pkgs; [
      # Packages
      brightnessctl
      cava
      cliphist
      coreutils
      ddcutil
      file
      findutils
      libnotify
      matugen
      swww
      wl-clipboard
      wlsunset
      # Fonts
      dejavu_fonts
      inter
      material-symbols
      roboto
    ];

    x86Inputs = with pkgs; [gpu-screen-recorder];

    buildInputs = allInputs ++ lib.optionals (lib.hasPrefix "x86" system) x86Inputs;
  in
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages.noctalia = pkgs.symlinkJoin {
        name = "noctalia-shell";
        paths = [inputs.noctalia.packages.${system}.default];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/noctalia-shell \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };
    };
}
