{pkgs, ...}: {
  environment.persistence."/persist".users.michael.directories = [
    ".cache/librewolf"
    ".librewolf"
  ];

  users.users.michael.packages = [pkgs.librewolf];
}
