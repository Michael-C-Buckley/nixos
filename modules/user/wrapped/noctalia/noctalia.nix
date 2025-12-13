{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    buildInputs = with pkgs; [
      # Packages
      brightnessctl
      cava
      cliphist
      coreutils
      ddcutil
      file
      findutils
      gpu-screen-recorder
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
  in {
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
