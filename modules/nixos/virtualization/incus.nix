{ pkgs, ... }: {
  virtualisation.incus = {
    enable = true;
    package = pkgs.incus; # Use the non-LTS package
    ui.enable = true;
  };
}
