# Common settings I have in all current systems
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.hjem
    ./users
    ./system/nix.nix
  ];

  environment.systemPackages =
    with pkgs;
    [
      vim
      neovim
      bat
      duf
      dust
      eza
      fd
      file
      fzf
      gh
      jq
      git
      ripgrep
      unzip
      sops
      age
      zoxide
      socat
      nix-tree

      # Terminfo
      alacritty.terminfo
      kitty.terminfo
      ghostty.terminfo
      tmux.terminfo
    ]
    ++ [
      inputs.rush.packages.${pkgs.stdenv.hostPlatform.system}.rush-shell
    ];

  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = false;
  };

  services = {
    # Farewell printing, read this article if you didn't know you could print with just netcat
    # https://retrohacker.substack.com/p/bye-cups-printing-with-netcat
    printing.enable = false;

    openssh = {
      enable = lib.mkDefault true;
      openFirewall = lib.mkDefault true;
    };
    # Use the OpenSSH Agent instead, defined below
    gnome.gcr-ssh-agent.enable = false;
  };

  systemd = {
    # See: https://www.openwall.com/lists/oss-security/2025/12/28/4
    generators.systemd-ssh-generator = "/dev/null";
    sockets.sshd-unix-local.enable = lib.mkForce false;
    sockets.sshd-vsock.enable = lib.mkForce false;
  };

  security = {
    sudo.extraConfig = "Defaults lecture=never";
    # RSSH lets me auth with my SSH keys and supports yubikey
    pam = {
      rssh.enable = true;
      services.sudo.rssh = true;
    };
  };

  programs = {
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      direnvrcExtra = ''
        warn_timeout=0
        hide_env_diff=true
      '';
    };
  };
}
