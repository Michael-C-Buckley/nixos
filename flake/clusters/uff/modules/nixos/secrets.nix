{
  config,
  inputs,
  ...
}: let
  inherit (config.sops.secrets) corosync-authkey wifi;
in {
  imports = [
    inputs.nix-secrets.nixosModules.uff
  ];
  users.users.hacluster.hashedPassword = "$y$j9T$8xT6SxLLcWTloOPU4gn/j0$UQNlMZGcUCWAkeqWWrrckBJL50oQYeMteeHJXQyMcq9";

  environment.etc = {
    "corosync/authkey".source = corosync-authkey.path;
    "NetworkManager/system-connections/wifi.nmconnection" = {
      source = wifi.path;
      mode = "0600";
    };
  };
}
