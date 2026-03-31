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
      # Required
      brightnessctl
      cliphist
      ddcutil
      wl-clipboard
      imagemagick
      wlsunset
      wlr-randr
      # Optional that I include
      cava
      libnotify
    ];

    fontDirectories = with pkgs; [
      dejavu_fonts
      inter
      material-symbols
      roboto
    ];

    # Not available on ARM
    x86Inputs = with pkgs; [gpu-screen-recorder];

    runtimeEnv = pkgs.buildEnv {
      name = "noctalia-runtime-env";
      pathsToLink = ["/bin"];
      paths = allInputs ++ lib.optionals (lib.hasPrefix "x86" system) x86Inputs;
    };
  in
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages.noctalia = pkgs.symlinkJoin {
        name = "noctalia-shell";
        paths = [pkgs.noctalia-shell];
        nativeBuildInputs = [pkgs.makeWrapper];
        meta.mainProgram = "noctalia-shell";
        postBuild = ''
          wrapProgram $out/bin/noctalia-shell \
            --prefix PATH : ${runtimeEnv}/bin \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {inherit fontDirectories;}}
        '';
      };
    };
}
