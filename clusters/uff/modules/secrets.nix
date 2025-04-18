{
  config,
  inputs,
  ...
}: let
  shh = config.sops.secrets;
in {
  imports = [
    inputs.nix-secrets.nixosModules.uff
  ];
  environment.etc = {
    "corosync/authkey".source = shh.corosync-authkey.path;
    "NetworkManager/system-connections/wifi.nmconnection" = {
      source = shh.wifi.path;
      mode = "0600";
    };
  };
}
