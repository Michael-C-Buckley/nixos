{ pkgs, ... }: {
  users.users = {
    shawn = {
      shell = pkgs.zsh;
      uid = 2001;
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ ];
    };
  };
}
