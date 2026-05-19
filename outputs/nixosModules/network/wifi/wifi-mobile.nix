# For laptops and mobile devices
let
  mkWifi = name: {
    sopsFile = "/etc/secrets/common/wifi/${name}.env";
    format = "dotenv";
    key = "";
  };
in {
  sops.secrets = {
    shawn-wifi = mkWifi "shawn";
    r1-wifi = mkWifi "r1";
    r2-wifi = mkWifi "r2";
  };
}
