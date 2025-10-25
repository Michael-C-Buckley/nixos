{
  flake.modules.nixos.hjem-shellAliases = let
    commonAliases = {
      ll = "eza -ala -g --icons";
      la = "eza -A"; # List all except `.` and `..`
      l = "ls -CF"; # Simple classified list
      lt = "eza --tree --level=2 --icons";
      tree = "eza --tree";
      cat = "bat -p";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";

      # Git aliases
      gst = "git status";
      ga = "git add";
      gaa = "git add *";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";
      gf = "git fetch";
      grv = "git remote -v";
      lg = "lazygit";

      # Kubernetes
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kgn = "kubectl get nodes";

      # Nu/Nushell
      n = "nu -c";

      # ZFS
      zls = "zfs list -o name,used,compressratio,lused,avail";
      zsls = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";

      # SSH bypass
      sshn = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null";

      # File Management
      duz = "du -xh . | sort -hr | fzf";

      # Programs
      fetch = "fastfetch --logo ~/.media/nixos.png --logo-height 20 --logo-width 40";
      nv = "nvim";

      # Calculate the evaluation time of the current host
      nht = ''
        time nix eval \
          "$NH_FLAKE"#nixosConfigurations."$hostname".config.system.build.toplevel \
          --substituters " " \
          --option eval-cache false \
          --raw --read-only
      '';
    };
  in {
    hjem.users.michael.rum.programs = {
      fish.aliases = commonAliases;
      nushell.aliases = commonAliases;
    };
  };
}
