{pkgs, ...}: {
  environment.persistence."/persist".users.michael.directories = [
    ".config/qutebrowser"
  ];
  users.users.michael = {
    packages = [pkgs.qutebrowser];
  };
}
