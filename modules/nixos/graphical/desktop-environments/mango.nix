{
  flake.modules.nixos.mango = {pkgs, ...}: {
    programs.mangowc = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
    ];
  };
}
