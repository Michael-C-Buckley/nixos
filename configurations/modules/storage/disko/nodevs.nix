{config}: let
  mainDisko = config.features.disko.main;
in {
  "/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=${mainDisko.rootSize}"
    ];
  };
}
