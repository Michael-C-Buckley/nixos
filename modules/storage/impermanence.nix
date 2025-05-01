# Mostly default example from Impermanence
{
  environment.persistence."/cache" = {
    hideMounts = true;
    users.michael.directories = [
      "Downloads"
    ];

  };
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/ssh"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/libvirtd"
      "/var/lib/docker"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
    users.michael = {
      directories = [
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "Projects"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"

        # Browsers
        ".cache/librewolf"
        ".config/.librewolf"
        ".cache/BraveSoftware"
        ".config/BraveSoftware"
      ];
      files = [
        ".screenrc"
      ];
    };
  };
}
