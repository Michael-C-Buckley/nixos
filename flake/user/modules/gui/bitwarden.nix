{pkgs, ...}: {
  environment.persistence."/persist".users.michael.directories = [
    ".config/Bitwarden"
  ];

  users.users.michael.packages = [
    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli
  ];
}
