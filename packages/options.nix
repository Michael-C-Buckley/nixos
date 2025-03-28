{ lib, ...}: { 
  
  options = {
    features.pkgs.netTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable networking tools.";
    };
    features.pkgs.fonts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include additional fonts.";
    };
  };
}