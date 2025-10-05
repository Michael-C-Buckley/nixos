{pkgs, ...}: {
  environment.persistence."/persist".users.michael.directories = [
    ".cache/librewolf"
  ];

  users.users.michael.packages = [pkgs.librewolf];
}
