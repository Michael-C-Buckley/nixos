{pkgs, ...}: {
  hjem.users.michael = {
    programs = {
      # keep-sorted start
      custom.ns.enable = true;
      nvf.enable = true;
      # keep-sorted end
    };
  };

  users.users.michael.packages = with pkgs; [
    ungoogled-chromium
  ];
}
