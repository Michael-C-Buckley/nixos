{
  flake.modules.nixos.packages-server = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # Display
      cage
      # Terminals
      ghostty
      sakura
    ];
  };
}
