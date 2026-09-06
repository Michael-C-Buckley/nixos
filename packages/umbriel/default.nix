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
  # extraConfig/extraBinds are merged in by the callers of each imported file
  settings =
    (import ./base.nix { inherit extraConfig; })
    // (import ./binds.nix {
      inherit
        pkgs
        workspaces
        browser
        terminal
        ;
      extraConfig = extraBinds;
    });
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
