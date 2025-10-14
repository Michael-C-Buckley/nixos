# A collection of GUI apps without strong declarations
{
  flake.nixosModules.guiPackages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      materialgram
      signal-desktop
      legcord
      bitwarden-desktop
      bitwarden-cli
      librewolf
      obsidian
    ];

    custom.impermanence = {
      cache.user.directories = [
        ".config/legcord/Cache"
        ".config/bitwarden"
        ".cache/librewolf"
        ".librewolf"
        ".config/Signal"

        # Helium, from my own packages
        ".config/net.imput.helium"
      ];
      persist.user.directories = [
        ".config/legcord"
        ".config/obsidian"
        # ".local/share/materialgram" # currently all of .local is cached
      ];
    };
  };
}
