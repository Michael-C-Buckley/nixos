{
  flake.modules.nixos.wifi-home = {
    sops.secrets = {
      michael-wifi = {
        sopsFile = "/etc/secrets/common/wifi/michael.env";
        format = "dotenv";
        key = "";
      };
    };
  };
}
