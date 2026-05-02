{inputs, ...}: {
  flake.modules.nixos.mango = {pkgs, ...}: {
    imports = [inputs.mango.nixosModules.mango];

    programs.mango = {
      enable = true;
      package = inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.mango;
    };

    environment.systemPackages = builtins.attrValues {
      inherit (pkgs) rofi waybar grim slurp wl-clipboard;
    };
  };
}
