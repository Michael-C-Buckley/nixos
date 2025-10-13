{pkgs, ...}: {
  environment.persistence."/persist".users.michael.directories = [
    ".config/Signal"
  ];

  users.users.michael = {
    packages = [pkgs.signal-desktop];
  };
}
