{
  flake.modules.nixos.wifi-home = {
    sops.secrets = {
      michael-wifi = {
        sopsFile = "/etc/secrets/wifi/michael.env";
        format = "dotenv";
        key = "";
      };
    };
  };
}
