{
  security = {
    sudo = {
      enable = true;
      extraConfig = "Defaults lecture=never";
    };
    pam = {
      rssh.enable = true;
      services.sudo.rssh = true;
    };
  };
}
