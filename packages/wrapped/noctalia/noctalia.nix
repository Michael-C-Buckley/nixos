# A fully wrapped Noctalia that is include all dependencies for normal
# operation and allows just in just-working status
#
# I still have configs declared in Hjem for declarative per-host needs
{
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

    # Not available on ARM
    x86Inputs = with pkgs; [gpu-screen-recorder];

    buildInputs = allInputs ++ lib.optionals (lib.hasPrefix "x86" system) x86Inputs;
  in
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages.noctalia = pkgs.symlinkJoin {
        name = "noctalia-shell";
        paths = [pkgs.noctalia-shell];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        meta.mainProgram = "noctalia-shell";
        postBuild = ''
          wrapProgram $out/bin/noctalia-shell \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };
    };
}
