{
  git,
  inputs,
  lib,
  makeWrapper,
  stdenvNoCC,
}:

let
  releasePin = "comview-${stdenvNoCC.hostPlatform.system}";
in
stdenvNoCC.mkDerivation {
  pname = "comview";
  version = inputs._meta.${releasePin}.version or "unstable";
  src = inputs.${releasePin};

  nativeBuildInputs = [ makeWrapper ];

  # Tack's fixed-output store path has no archive extension.
  unpackCmd = ''tar -xzf "$curSrc"'';
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 comview "$out/bin/comview"
    install -Dm644 README.md "$out/share/doc/comview/README.md"
    install -Dm644 LICENSE "$out/share/licenses/comview/LICENSE"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/comview" --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  meta = {
    description = "Interactive terminal viewer for unified diffs";
    homepage = "https://github.com/rockorager/comview";
    license = lib.licenses.mit;
    mainProgram = "comview";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
