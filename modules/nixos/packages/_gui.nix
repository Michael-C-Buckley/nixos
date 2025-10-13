# A collection of GUI apps without strong declarations
{
  host = {
    graphicalPackages = [
      "materialgram"
      "signal-desktop"
      "legcord"
      "bitwarden-desktop"
      "bitwarden-cli"
      "librewolf"
      "obsidian"
    ];

    impermanence = {
      cache.user.directories = [
        ".config/legcord/Cache"
        ".config/bitwarden"
        ".cache/librewolf"
        ".librewolf"

        # Helium, from my own packages
        ".config/net.imput.helium"
      ];
      persist.user.directories = [
        ".config/legcord"
        ".config/signal-desktop"
        ".config/obsidian"
        # ".local/share/materialgram" # currently all of .local is cached
      ];
    };
  };
}
