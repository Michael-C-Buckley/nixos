{
  perSystem = {pkgs, ...}: {
    # The full package is ~900MB and I use literally only 1 color
    # So, debloat by hitching all the rest from nixpkgs
    # Original source was from `pkgs.nordzy-cursor-theme`
    packages.nordzy-cursor = pkgs.stdenv.mkDerivation {
      pname = "nordzy-cursor-white";
      version = "1.0";

      src = pkgs.nordzy-cursor-theme;

      installPhase = ''
        mkdir -p $out/share/icons
        cp -r share/icons/Nordzy-cursors-white $out/share/icons/Nordzy-cursors-white
        cp -r share/icons/Nordzy-hyprcursors-white $out/share/icons/Nordzy-hyprcursors-white
      '';

      meta = {
        description = "Nordzy Cursor - White";
        platforms = pkgs.lib.platforms.linux;
      };
    };
  };
}
