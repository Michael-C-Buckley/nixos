# Simple patch derivation that grabs the official release so it
# doesn't have to rebuild from source
{
  autoPatchelfHook,
  inputs,
  lib,
  libgcc,
  stdenvNoCC,
  zstd,
}:
let
  releasePin = "tack-${stdenvNoCC.hostPlatform.system}";
in
stdenvNoCC.mkDerivation {
  pname = "tack";
  version = inputs._meta.${releasePin}.version or "unstable";
  src = inputs.${releasePin};

  strictDeps = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    libgcc
    zstd
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/tack"
    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/tack" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Flake-like TOML pins for Nix";
    homepage = "https://github.com/manic-systems/tack";
    license = lib.licenses.eupl12;
    mainProgram = "tack";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
