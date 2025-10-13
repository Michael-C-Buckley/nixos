{pkgs, ...}: {
  environment.persistence."/cache".users.michael.directories = [
    ".config/obsidian"
  ];

  users.users.michael = {
    packages = [pkgs.obsidian];
  };
}
