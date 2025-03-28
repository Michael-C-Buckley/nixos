{inputs, ...}: let
  allGroups = ["networkmanager" "wheel" "video" "wireshark"];
in {
  imports = [
    inputs.nix-secrets.nixosModules.users
  ];

  users.users = {
    michael = {
      isNormalUser = true;
      extraGroups = allGroups;
    };
    shawn = {
      isNormalUser = true;
      extraGroups = allGroups;
    };
  };
}
