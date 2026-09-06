{ pkgs, ... }:
pkgs.writers.writeNuBin "git-credential-sops"
  # nushell
  ''
    const GIT = "${pkgs.lib.getExe pkgs.git}"
    const SOPS = "${pkgs.lib.getExe pkgs.sops}"

    def fail [message: string] {
      print -e $"git-credential-sops: ($message)"
      exit 1
    }

    def --wrapped capture [program: string, ...args: string] {
      do { run-external $program ...$args } | complete
    }

    def --wrapped checked-output [program: string, ...args: string] {
      let result = (capture $program ...$args)
      if $result.exit_code != 0 {
        let detail = ($result.stderr | str trim)
        if ($detail | is-empty) {
          fail $"command failed: ($program) ($args | str join ' ')"
        } else {
          fail $detail
        }
      }
      $result.stdout | str trim
    }

    def --wrapped checked-run [program: string, ...args: string] {
      checked-output $program ...$args | ignore
    }

    def consume-request [] {
      open --raw /dev/stdin | lines | take until {|line| $line == "" } | ignore
    }

    # Configure the current repository to decrypt its HTTPS token with SOPS.
    def "main configure" [
      sops_file: path              # SOPS file, absolute or relative to the repository root.
      --extract: string = ""       # SOPS extraction expression, such as '["github-token"]'.
      --username: string = "x-access-token" # HTTPS username supplied to Git.
      --ssh-key: path              # SSH private key used as an AGE identity.
      --age-key-file: path         # File containing one or more AGE identities.
    ] {
      let root_result = (capture $GIT rev-parse --show-toplevel)
      if $root_result.exit_code != 0 {
        fail "configure must be run inside a Git working tree"
      }

      let root = ($root_result.stdout | str trim)
      let prefix = (checked-output $GIT rev-parse --show-prefix)
      let stored_file = if ($sops_file | str starts-with "/") {
        $sops_file
      } else {
        $"($prefix)($sops_file)"
      }
      let secret_file = if ($stored_file | str starts-with "/") {
        $stored_file
      } else {
        $root | path join $stored_file
      }

      if not ($secret_file | path exists) {
        fail $"SOPS file does not exist: ($secret_file)"
      }
      if ($username | str contains (char nl)) {
        fail "username must not contain a newline"
      }

      let default_ssh_key = ($env.HOME | path join ".ssh" "id_ed25519")
      let configured_ssh_key = if $ssh_key != null {
        $ssh_key | path expand
      } else if ($default_ssh_key | path exists) {
        $default_ssh_key
      } else {
        ""
      }
      let configured_age_key_file = if $age_key_file != null {
        $age_key_file | path expand
      } else {
        ""
      }

      if not ($configured_ssh_key | is-empty) and not ($configured_ssh_key | path exists) {
        fail $"SSH private key does not exist: ($configured_ssh_key)"
      }
      if not ($configured_age_key_file | is-empty) and not ($configured_age_key_file | path exists) {
        fail $"AGE identity file does not exist: ($configured_age_key_file)"
      }

      checked-run $GIT config --local credential.sopsFile $stored_file
      checked-run $GIT config --local credential.sopsUsername $username
      if ($extract | is-empty) {
        capture $GIT config --local --unset-all credential.sopsExtract | ignore
      } else {
        checked-run $GIT config --local credential.sopsExtract $extract
      }
      if ($configured_ssh_key | is-empty) {
        capture $GIT config --local --unset-all credential.sopsSshKey | ignore
      } else {
        checked-run $GIT config --local credential.sopsSshKey $configured_ssh_key
      }
      if ($configured_age_key_file | is-empty) {
        capture $GIT config --local --unset-all credential.sopsAgeKeyFile | ignore
      } else {
        checked-run $GIT config --local credential.sopsAgeKeyFile $configured_age_key_file
      }

      # An empty helper resets inherited helpers before Git invokes this one.
      checked-run $GIT config --local --replace-all credential.helper ""
      # Let Git resolve `git-credential-sops` from PATH instead of persisting
      # this executable's garbage-collectable /nix/store path.
      checked-run $GIT config --local --add credential.helper "sops"

      print $"Configured SOPS credentials for ($root)"
    }

    # Remove the SOPS credential settings from the current repository.
    def "main unconfigure" [] {
      let repository = (capture $GIT rev-parse --git-dir)
      if $repository.exit_code != 0 {
        fail "unconfigure must be run inside a Git repository"
      }

      for key in [
        credential.sopsFile
        credential.sopsUsername
        credential.sopsExtract
        credential.sopsSshKey
        credential.sopsAgeKeyFile
        credential.helper
      ] {
        capture $GIT config --local --unset-all $key | ignore
      }
      print "Removed SOPS credential configuration"
    }

    # Return the configured credential using Git's credential-helper protocol.
    def "main get" [] {
      consume-request

      let root_result = (capture $GIT rev-parse --show-toplevel)
      if $root_result.exit_code != 0 {
        fail "Git did not invoke the helper from a working tree"
      }
      let root = ($root_result.stdout | str trim)

      let file_result = (capture $GIT config --local --get credential.sopsFile)
      if $file_result.exit_code != 0 {
        fail "credential.sopsFile is not configured; run 'git-credential-sops configure'"
      }
      let stored_file = ($file_result.stdout | str trim)
      let secret_file = if ($stored_file | str starts-with "/") {
        $stored_file
      } else {
        $root | path join $stored_file
      }
      if not ($secret_file | path exists) {
        fail $"SOPS file does not exist: ($secret_file)"
      }

      let username_result = (capture $GIT config --local --get credential.sopsUsername)
      let configured_username = ($username_result.stdout | str trim)
      let username = if $username_result.exit_code == 0 and not ($configured_username | is-empty) {
        $configured_username
      } else {
        "x-access-token"
      }

      let extract_result = (capture $GIT config --local --get credential.sopsExtract)
      let extract = if $extract_result.exit_code == 0 {
        $extract_result.stdout | str trim
      } else {
        ""
      }
      let sops_args = if ($extract | is-empty) {
        ["--decrypt" $secret_file]
      } else {
        ["--decrypt" "--extract" $extract $secret_file]
      }

      let ssh_key_result = (capture $GIT config --local --get credential.sopsSshKey)
      let ssh_key = if $ssh_key_result.exit_code == 0 {
        $ssh_key_result.stdout | str trim
      } else {
        ""
      }
      let age_key_result = (capture $GIT config --local --get credential.sopsAgeKeyFile)
      let age_key_file = if $age_key_result.exit_code == 0 {
        $age_key_result.stdout | str trim
      } else {
        ""
      }
      let ssh_environment = if ($ssh_key | is-empty) {
        {}
      } else {
        {SOPS_AGE_SSH_PRIVATE_KEY_FILE: $ssh_key}
      }
      let age_environment = if ($age_key_file | is-empty) {
        if ($ssh_key | is-empty) {
          {}
        } else {
          # Do not load the default AGE identity file when an SSH identity was
          # selected. It may contain plugin identities which prompt even when
          # the SSH identity can decrypt a later recipient.
          {
            SOPS_AGE_KEY_FILE: "/dev/null"
            # Plugin recipients invoke their executable directly. The SOPS
            # binary and SSH identity handling do not require PATH lookups.
            PATH: []
          }
        }
      } else {
        {SOPS_AGE_KEY_FILE: $age_key_file}
      }
      let sops_environment = ($ssh_environment | merge $age_environment)
      let decrypted = (with-env $sops_environment { capture $SOPS ...$sops_args })
      if $decrypted.exit_code != 0 {
        fail $"could not decrypt token from ($secret_file): ($decrypted.stderr | str trim)"
      }

      let token_lines = ($decrypted.stdout | lines)
      if ($token_lines | length) != 1 {
        fail "decrypted value must contain exactly one non-empty line; configure an --extract expression"
      }
      let token = ($token_lines | first)
      if ($token | is-empty) {
        fail "decrypted token is empty"
      }

      print $"username=($username)\npassword=($token)\n"
    }

    # SOPS is the source of truth, so Git has nothing to persist on store.
    def "main store" [] {
      consume-request
    }

    # SOPS is the source of truth, so Git has nothing to erase.
    def "main erase" [] {
      consume-request
    }

    def main [] {
      print -e "Run 'git-credential-sops --help' for usage."
      exit 2
    }
  ''
