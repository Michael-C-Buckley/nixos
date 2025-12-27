# Migration Strategy: GPG to SSH Commit Signing

This document outlines the strategy for resigning all commits in this repository using SSH keys instead of GPG keys.

## ⚠️ Important Considerations

**Rewriting history will change all commit hashes.** This has significant implications:

1. **Force push required** - All branches will need force pushes
2. **Collaborator impact** - Anyone with local clones will need to re-clone or reset their branches
3. **PR/Issue references** - Any references to commit SHAs in issues, PRs, or external systems will break
4. **Deployment pipelines** - CI/CD that references specific commits will need updates
5. **Dependent repositories** - Any flakes or systems that pin to specific commits of this repo will need updates

## Prerequisites

### 1. Generate or Identify Your SSH Signing Key

```bash
# Generate a new Ed25519 key specifically for signing (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519_signing

# Or use an existing SSH key
```

### 2. Configure Git for SSH Signing

```bash
# Set SSH as the signing format
git config --global gpg.format ssh

# Point to your signing key
git config --global user.signingkey ~/.ssh/id_ed25519_signing.pub

# Enable commit signing by default
git config --global commit.gpgsign true

# Enable tag signing by default  
git config --global tag.gpgsign true
```

### 3. Add SSH Key to GitHub

1. Go to GitHub → Settings → SSH and GPG keys
2. Click "New SSH key"
3. Select "Signing Key" as the key type
4. Paste your public key content
5. Save

### 4. Configure Allowed Signers (for local verification)

Create an allowed signers file:

```bash
mkdir -p ~/.config/git
echo "your_email@example.com $(cat ~/.ssh/id_ed25519_signing.pub)" > ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

## Migration Options

### Option A: Fresh Start (Recommended for Small Repos)

If the repository has a small number of commits and no external dependencies:

1. **Export your current work**
2. **Create a new repository**
3. **Re-commit with SSH signing enabled**

This is the cleanest approach but loses commit history metadata (dates, order of changes).

### Option B: Rebase with Signing (For Linear History)

For repositories with linear history:

```bash
# Ensure SSH signing is configured (see Prerequisites)

# Rebase all commits and resign them
git rebase --root --exec 'git commit --amend --no-edit -S'

# Force push to remote
git push --force-with-lease origin main
```

### Option C: Git Filter-Repo (Recommended for Complex History)

[git-filter-repo](https://github.com/newren/git-filter-repo) is the modern replacement for filter-branch.

#### Installation

```bash
# On NixOS (add to shell.nix or use nix-shell)
nix-shell -p git-filter-repo

# Or with pip
pip install git-filter-repo

# Or with homebrew
brew install git-filter-repo
```

#### Migration Script

Create a script to resign all commits:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
REPO_PATH="/path/to/your/repo"
BACKUP_PATH="/path/to/backup"

# Backup first!
echo "Creating backup..."
cp -r "$REPO_PATH" "$BACKUP_PATH"

cd "$REPO_PATH"

# Run filter-repo to strip GPG signatures
git filter-repo --commit-callback 'commit.gpgsig = None' --force

# Now resign each commit with SSH
git rebase --root --exec 'git commit --amend --no-edit -S'

echo "Migration complete!"
echo "Verify with: git log --show-signature"
```

### Option D: Interactive Rebase (For Selective Commits)

If you only need to resign specific commits:

```bash
# Start interactive rebase from root
git rebase -i --root

# In the editor, change 'pick' to 'edit' for commits to resign
# Save and exit

# For each commit that stops:
git commit --amend --no-edit -S
git rebase --continue

# Repeat until complete
```

## Recommended Approach for This Repository

Based on the repository structure (NixOS flake configuration), I recommend:

### Step-by-Step Migration

1. **Backup everything first**
   ```bash
   cd /path/to/parent/directory
   tar -czvf nixos-backup-$(date +%Y%m%d).tar.gz nixos/
   ```

2. **Ensure SSH signing is configured** (see Prerequisites above)

3. **Clone a fresh copy** (to avoid any local state issues)
   ```bash
   git clone --mirror https://github.com/Michael-C-Buckley/nixos.git nixos-mirror
   cd nixos-mirror
   ```

4. **Strip old signatures and rewrite history**
   ```bash
   # Install git-filter-repo
   nix-shell -p git-filter-repo
   
   # Strip GPG signatures
   git filter-repo --commit-callback 'commit.gpgsig = None' --force
   ```

5. **Convert back to regular repository and resign**
   ```bash
   # Clone the filtered mirror to a working directory
   git clone nixos-mirror nixos-resigned
   cd nixos-resigned
   
   # Resign all commits with SSH
   git rebase --root --exec 'git commit --amend --no-edit -S'
   ```

6. **Verify signatures**
   ```bash
   git log --show-signature -10
   ```

7. **Force push all branches**
   ```bash
   git push --force-with-lease --all origin
   git push --force-with-lease --tags origin
   ```

## Post-Migration Tasks

1. **Update any dependent flakes** that reference this repository by commit hash
2. **Notify collaborators** to re-clone the repository
3. **Update CI/CD pipelines** if they reference specific commit SHAs
4. **Remove GPG key from GitHub** (optional, but recommended for security)
5. **Revoke compromised GPG key** if applicable

## Verification

After migration, verify your commits are properly signed:

```bash
# Check recent commits
git log --show-signature -5

# Verify on GitHub
# Go to the repository commits page - signed commits will show "Verified" badge
```

## Troubleshooting

### "gpg.ssh.allowedSignersFile needs to be configured"

```bash
# Create allowed signers file
mkdir -p ~/.config/git
echo "your_email@example.com $(cat ~/.ssh/id_ed25519_signing.pub)" > ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

### "error: cannot run ssh-keygen: No such file or directory"

Ensure OpenSSH is installed and `ssh-keygen` is in your PATH.

### Commits still show as unverified on GitHub

1. Ensure your signing key is added to GitHub as a "Signing Key"
2. Ensure the email in your commits matches your GitHub email
3. Ensure the key fingerprint matches

## Rollback Plan

If something goes wrong:

1. **Use your backup** created in step 1
2. Or **use GitHub's backup** - GitHub retains the original refs for 30+ days after force push
3. Contact GitHub support if needed for recovery

## Security Notes

- **Keep your SSH signing key secure** - treat it like your GPG key
- **Use a passphrase** on your SSH key
- **Consider a hardware key** (YubiKey, etc.) for additional security
- **Regularly rotate keys** according to your security policy

## References

- [GitHub: Signing commits with SSH](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- [Git: gpg.format configuration](https://git-scm.com/docs/git-config#Documentation/git-config.txt-gpgformat)
- [git-filter-repo documentation](https://htmlpreview.github.io/?https://github.com/newren/git-filter-repo/blob/docs/html/git-filter-repo.html)
