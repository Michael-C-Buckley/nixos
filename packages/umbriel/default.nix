{
  pkgs,
  workspaces ? 10,
  browser ? "helium",
  terminal ? "kitty",
  extraConfig ? { },
  extraBinds ? { },
  ...
}:
let
  inherit (pkgs.lib)
    filterAttrs
    listToAttrs
    range
    recursiveUpdate
    ;

  sourceConfig = builtins.fromTOML (builtins.readFile ./config.toml);

  generatedConfig = {
    keybinds = {
      "Mod+B" = "spawn:${browser}";
      "Mod+Return" = "spawn:${terminal}";
    };
  };
  mergedConfig = recursiveUpdate (recursiveUpdate sourceConfig generatedConfig) extraConfig;
  settings = mergedConfig // {
    keybinds = mergedConfig.keybinds // extraBinds;
  };
  settingsToml = pkgs.writers.writeTOML "umbriel.toml" settings;
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "umbriel-config";
  version = "0-unstable";

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    cp ${settingsToml} umbriel.toml
    runHook postBuild
  '';

  # Lint the generated config with umbriel's own validator before it can be installed
  nativeCheckInputs = [ pkgs.umbriel ];
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    umbriel validate -c umbriel.toml
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 umbriel.toml "$out/umbriel.toml"
    runHook postInstall
  '';
}
