{ lib, pkgs, ... }:
let
  textTypes = lib.genAttrs [
    "text/plain"
    "text/markdown"
    "text/xml"
    "text/yaml"
    "text/x-log"
    "text/x-nix"
    "text/x-python"
    "text/x-rust"
    "text/x-go"
    "text/x-csrc"
    "text/x-chdr"
    "text/x-c++src"
    "text/x-c++hdr"
    "text/x-java"
    "text/javascript"
    "text/x-diff"
    "text/x-patch"
    "application/javascript"
    "application/json"
    "application/ld+json"
    "application/xml"
    "application/yaml"
    "application/toml"
    "application/x-shellscript"
    "application/x-zerosize"
    "x-scheme-handler/zed"
  ] (_: "dev.zed.Zed.desktop");

  webTypes = lib.genAttrs [
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "text/html"
    "application/xhtml+xml"
  ] (_: "helium.desktop");

  # Match the formats advertised by imv's desktop entry.
  imageTypes = lib.genAttrs [
    "image/x-farbfeld"
    "image/tiff"
    "image/tiff-fx"
    "image/png"
    "image/x-png"
    "image/jpeg"
    "image/jpg"
    "image/pjpeg"
    "image/svg+xml"
    "image/gif"
    "image/bmp"
    "image/x-bmp"
    "image/heif"
    "image/avif"
    "image/jxl"
    "image/webp"
    "image/qoi"
  ] (_: "imv.desktop");

  archiveTypes = lib.genAttrs [
    "application/zip"
    "application/x-7z-compressed"
    "application/vnd.rar"
    "application/x-rar"
    "application/x-rar-compressed"
    "application/x-tar"
    "application/x-compressed-tar"
    "application/x-bzip-compressed-tar"
    "application/x-xz-compressed-tar"
    "application/x-lzma-compressed-tar"
    "application/x-zstd-compressed-tar"
    "application/gzip"
    "application/x-gzip"
    "application/x-bzip2"
    "application/x-xz"
    "application/zstd"
  ] (_: "xarchiver.desktop");

  documentTypes = lib.genAttrs [
    "application/vnd.oasis.opendocument.text"
    "application/vnd.oasis.opendocument.text-template"
    "application/msword"
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
    "application/rtf"
    "text/rtf"
  ] (_: "libreoffice-writer.desktop");

  spreadsheetTypes = lib.genAttrs [
    "application/vnd.oasis.opendocument.spreadsheet"
    "application/vnd.oasis.opendocument.spreadsheet-template"
    "application/vnd.ms-excel"
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
    "text/csv"
    "text/tab-separated-values"
  ] (_: "libreoffice-calc.desktop");

  presentationTypes = lib.genAttrs [
    "application/vnd.oasis.opendocument.presentation"
    "application/vnd.oasis.opendocument.presentation-template"
    "application/vnd.ms-powerpoint"
    "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    "application/vnd.openxmlformats-officedocument.presentationml.template"
    "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
  ] (_: "libreoffice-impress.desktop");
in
{
  environment.systemPackages = [ pkgs.xdg-utils ];

  # User associations in ~/.config/mimeapps.list take precedence.
  xdg.mime = {
    enable = true;
    defaultApplications =
      textTypes
      // webTypes
      // imageTypes
      // archiveTypes
      // documentTypes
      // spreadsheetTypes
      // presentationTypes
      // {
        "audio/*" = "mpv.desktop";
        "video/*" = "mpv.desktop";
        "application/ogg" = "mpv.desktop";
        "application/pdf" = "org.gnome.Papers.desktop";
        "application/x-matroska" = "mpv.desktop";
        "application/vnd.oasis.opendocument.graphics" = "libreoffice-draw.desktop";
        "application/vnd.oasis.opendocument.graphics-template" = "libreoffice-draw.desktop";
        "inode/directory" = "pcmanfm.desktop";

        "x-scheme-handler/discord" = "legcord.desktop";
        "x-scheme-handler/sgnl" = "signal.desktop";
        "x-scheme-handler/signalcaptcha" = "signal.desktop";
        "x-scheme-handler/tg" = "io.github.kukuruzka165.materialgram.desktop";
      };
  };
}
