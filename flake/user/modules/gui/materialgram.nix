{pkgs, ...}: {
  users.users.michael = {
    packages = [pkgs.materialgram];
  };
}
