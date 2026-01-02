# Derivation based on the original from the Glide team:
# https://github.com/glide-browser/glide.nix/blob/main/package.nix
# Which in turn came from Pyrox:
# https://git.pyrox.dev/pyrox/nix/src/branch/main/packages/glide-browser-bin/package.nix
{
  pkgs,
  lib,
  stdenv,
  adwaita-icon-theme,
  alsa-lib,
  autoPatchelfHook,
  copyDesktopItems,
  curl,
  dbus-glib,
  gtk3,
  hicolor-icon-theme,
  libXtst,
  libva,
  makeBinaryWrapper,
  makeDesktopItem,
  patchelfUnstable,
  pciutils,
  pipewire,
  wrapGAppsHook3,
  nix-update-script,
  ...
}:
stdenv.mkDerivation (finalAttrs: let
  glideSrc = let
    sources = pkgs.callPackage ../../_sources/generated.nix {};
  in
    if stdenv.isLinux
    then sources.glide
    else sources."glide-mac";
in {
  inherit (glideSrc) src pname version;

  nativeBuildInputs =
    [
      copyDesktopItems
      makeBinaryWrapper
    ]
    ++ lib.optionals stdenv.isLinux [
      autoPatchelfHook
      patchelfUnstable
      wrapGAppsHook3
    ];

  buildInputs = lib.optionals stdenv.isLinux [
    adwaita-icon-theme
    alsa-lib
    dbus-glib
    gtk3
    hicolor-icon-theme
    libXtst
  ];

  runtimeDependencies = lib.optionals stdenv.isLinux [
    curl
    libva.out
    pciutils
  ];

  appendRunpaths = lib.optionals stdenv.isLinux ["${pipewire}/lib"];

  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = lib.optionals stdenv.isLinux ["--no-clobber-old-sections"];

  unpackPhase = lib.optionalString stdenv.isDarwin ''
    runHook preUnpack

    /usr/bin/hdiutil attach -nobrowse -readonly $src
    cp -r /Volumes/Glide/Glide.app .
    /usr/bin/hdiutil detach /Volumes/Glide

    runHook postUnpack
  '';

  installPhase =
    if stdenv.isLinux
    then ''
      runHook preInstall

      mkdir -p $out/bin $out/share/icons/hicolor/ $out/lib/glide-browser-bin-${finalAttrs.version}
      cp -t $out/lib/glide-browser-bin-${finalAttrs.version} -r *
      chmod +x $out/lib/glide-browser-bin-${finalAttrs.version}/glide
      iconDir=$out/share/icons/hicolor
      browserIcons=$out/lib/glide-browser-bin-${finalAttrs.version}/browser/chrome/icons/default

      for i in 16 32 48 64 128; do
        iconSizeDir="$iconDir/''${i}x$i/apps"
        mkdir -p $iconSizeDir
        cp $browserIcons/default$i.png $iconSizeDir/glide-browser.png
      done

      ln -s $out/lib/glide-browser-bin-${finalAttrs.version}/glide $out/bin/glide
      ln -s $out/bin/glide $out/bin/glide-browser

      runHook postInstall
    ''
    else ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r Glide.app $out/Applications/

      mkdir -p $out/bin
      ln -s $out/Applications/Glide.app/Contents/MacOS/glide $out/bin/glide
      ln -s $out/bin/glide $out/bin/glide-browser

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = "glide-browser-bin";
      exec = "glide-browser --name glide-browser %U";
      icon = "glide-browser";
      desktopName = "Glide Browser";
      genericName = "Web Browser";
      terminal = false;
      startupNotify = true;
      startupWMClass = "glide-browser";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      actions = {
        new-window = {
          name = "New Window";
          exec = "glide-browser --new-window %U";
        };
        new-private-window = {
          name = "New Private Window";
          exec = "glide-browser --private-window %U";
        };
        profile-manager-window = {
          name = "Profile Manager";
          exec = "glide-browser --ProfileManager";
        };
      };
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--url"
      "https://github.com/glide-browser/glide"
    ];
  };

  meta = {
    changelog = "https://glide-browser.app/changelog#${finalAttrs.version}";
    description = "Extensible and keyboard-focused web browser, based on Firefox (binary package)";
    homepage = "https://glide-browser.app/";
    license = lib.licenses.mpl20;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "glide-browser";
  };
})
