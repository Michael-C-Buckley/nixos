{lib, ...}: {
    options = {
    system.impermanence = {
      enable = lib.mkEnableOption "Enable Impermanence on the system's storage";
    };
  };
}