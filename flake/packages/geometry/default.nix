{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "geometry-zsh";
  version = "0f82c56"; # Last commit

  src = fetchFromGitHub {
    owner = "geometry-zsh";
    repo = "geometry";
    rev = "0f82c567db277024f340b5854a646094d194a31f";
    sha256 = "sha256-FoOY7dkeYC7xQJkX06IDZdduXCfpDxB2aHoSludAMbI=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp geometry.zsh $out/
    cp -r functions/ $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A minimal, composable zsh prompt theme";
    homepage = "https://github.com/geometry-zsh/geometry";
    license = licenses.isc;
    maintainers = [];
    platforms = platforms.all;
  };
}
