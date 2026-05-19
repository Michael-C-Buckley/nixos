{
  npins,
  pkgs,
  ...
}: {
  imports = ["${npins."binhost.nix"}/lanzaboote/modules"];
  environment.systemPackages = [pkgs.sbctl];

  boot = {
    loader.systemd-boot.enable = false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
