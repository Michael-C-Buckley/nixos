{
  pkgs,
  flake,
  ...
}: {
  imports = with flake.nixosModules; [
    cursor
    helium
    qt
  ];

  hjem.users.michael = {
    packages = with pkgs; [
      novelwriter
    ];

    environment.sessionVariables = {
      BROWSER = "helium";
      NIXOS_OZONE_WL = "1";
      GTK_USE_PORTAL = "1";
    };
  };
}
