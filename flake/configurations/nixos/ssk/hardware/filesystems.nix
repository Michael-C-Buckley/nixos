_: {
  system = {
    boot.uuid = "3A0E-2554";

    impermanence = {
      enable = true;
      zrootPath = "ZROOT/nixos";
    };
  };

  # Preserve everything for root
  environment.persistence."/persist".directories = ["/root"];
}
