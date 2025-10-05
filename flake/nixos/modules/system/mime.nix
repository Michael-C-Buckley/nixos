{lib, ...}: let
  browserMimes = [
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "text/html"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/xhtml+xml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ];

  createBrowserList = browsers:
    lib.listToAttrs (map (mimeType: {
        name = mimeType;
        value = browsers;
      })
      browserMimes);
in {
  xdg.mime = {
    enable = true;

    defaultApplications = createBrowserList ["firefox.desktop"];
    addedAssociations = createBrowserList [
      "firefox.desktop"
      "librewolf.desktop"
    ];
  };
}
