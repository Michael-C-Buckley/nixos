{pkgs, ...}: {
  environment.persistence = {
    "/persist".users.michael.directories = [".config/legcord"];
    "/cache".users.michael.directories = [".config/legcord/Cache"];
  };
  users.users.michael.packages = [pkgs.legcord];
}
