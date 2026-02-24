{
  flake.userModules.shellAliases = {
    basic = {
      aa = "echo (whoami)@(hostname)";
      l = "ls -CF";
      ll = "ls -la";
      la = "ls -a";
      ".." = "cd ..";
      "..." = "cd ../..";
      sshn = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null";
      nv = "nvim";
    };

    extra = {
      lt = "eza --tree --level=2 --icons";
      tree = "eza --tree";
      cat = "bat -p";
      nht = ''time nix eval "$NH_FLAKE"#nixosConfigurations."$hostname".config.system.build.toplevel --substituters " " --option eval-cache false --raw --read-only'';

      gst = "git status";
      ga = "git add";
      gaa = "git add *";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";
      gf = "git fetch";
      grv = "git remote -v";
      lg = "lazygit";

      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kgn = "kubectl get nodes";

      zls = "zfs list -o name,used,compressratio,lused,avail";
      zsls = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";
    };

    fish = {
      ll = "eza -ala -g --icons";
      la = "eza -A";
      duz = "du -xh . | sort -hr | fzf";
      n = "nu -c";
    };

    nu = {
      ll = "ls -la";
      la = "ls -a";
      fg = "job unfreeze";
    };
  };
}
