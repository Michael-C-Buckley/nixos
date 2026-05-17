{
  flake.modules.nixos.shawn = {
    config,
    pkgs,
    ...
  }: {
    programs.zsh.enable = true;

    users = {
      powerUsers.members = ["shawn"];
      users.shawn = {
        initialHashedPassword = "$6$qqfYcXgaiZknCMEO$vQWbS.ojgq1Z278tlMxXuHXwwXIbvnuYifD7InXpvzdg.jLYcMoawE1GGtJzEVGJGn80PLfT1cMVMlcsaX3h5.";
        isNormalUser = true;
        extraGroups = config.users.powerUsers.groups;
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMHGkt46r4YJfNSji+DpfwlU/kCRVBwLAbUFbvyN2Ax1"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIW/Nlbf1An3q7yoWY5D6wYSm8Y5tWFtTMJm0pImjK1g"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKsayKA+q+xhiZtvQ58Xxl4tQq+zVVyYJwLP9BruIEphQsxe3pVqoQG25f+irYX0rqPij3bNZM3Dc/tejX2vDjI="
        ];
      };
    };
  };
}
