{pkgs, ...}: {
  environment.persistence."/persist".users.michael.directories = [
    ".config/signal"
  ];

  users.users.michael = {
    packages = [pkgs.signal-desktop];
  };
}
