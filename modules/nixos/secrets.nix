{
  flake.modules.nixos.secrets = {
    # Updates my local private secrets
    # Impure and imperative, I cannot say I recommend this approach
    # but it is one I'm testing out
    system.activationScripts.pullSecretsRepo = {
      deps = [];
      text = ''
        echo "[secrets-update] Checking for secrets repo in /etc/secrets"
        if [ ! -d /etc/secrets/.git ]; then
          echo "No git repo found in /etc/secrets; skipping pull"
          exit 0
        fi
        cd /etc/secrets/
        if [ -d .git ]; then
          git pull --ff-only
        fi
        if git pull --ff-only; then
          echo "[secrets-update] Pull successful"
        else
          echo "[secrets-update] Pull failed"
          exit 0
        fi
      '';
    };
  };
}
