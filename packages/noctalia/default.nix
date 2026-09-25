{ pkgs, ... }:
let
  inherit (pkgs) lib;
  defaultSettings = builtins.fromTOML (builtins.readFile ./config.toml);

  # extraSettings is recursively merged over defaultSettings, so callers only need to specify what they're changing
  mkNoctaliaConfig = lib.makeOverridable (
    {
      extraSettings ? { },
    }:
    let
      settings = lib.recursiveUpdate defaultSettings extraSettings;
      settingsToml = pkgs.writers.writeTOML "settings.toml" settings;
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "noctalia-config";
      version = "0-unstable";

      dontUnpack = true;

      buildPhase = ''
        runHook preBuild
        cp ${settingsToml} settings.toml
        runHook postBuild
      '';

      # Lint the generated config with noctalia's own validator before it can be installed
      nativeCheckInputs = [ pkgs.noctalia ];
      doCheck = true;
      checkPhase = ''
        runHook preCheck
        noctalia config validate settings.toml
        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall
        install -Dm444 settings.toml "$out/settings.toml"
        runHook postInstall
      '';
    }
  );
in
mkNoctaliaConfig { }
