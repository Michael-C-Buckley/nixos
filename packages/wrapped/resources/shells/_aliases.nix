{
  # Common aliases shared across shells
  common = {
    aa = "echo (whoami)@(hostname)";

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

    # ZFS
    zls = "zfs list -o name,used,compressratio,lused,avail";
    zsls = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";

    # SSH bypass
    sshn = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null";

    # Programs
    nv = "nvim";

    # Calculate the evaluation time of the current host
    nht = ''time nix eval "$NH_FLAKE"#nixosConfigurations."$hostname".config.system.build.toplevel --substituters " " --option eval-cache false --raw --read-only'';
  };

  # Fish-specific aliases
  fish = {
    l = "ls -CF";
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
}
