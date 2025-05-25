{config}: let
  mainDisko = config.system.disko.main;
in {
  "/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=${mainDisko.rootSize}"
    ];
  };
}
