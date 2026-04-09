#!/usr/bin/env nu

# Script to dynamically find which valid signing key is connected via my agent
# Mostly for use with my yubikeys as I have multiple and forward among remotes

# Returns 0 unconditionally in all cases to prevent issues with automation breaking
# it just provides a simple warning if it fails to get a valid key

# Check the OS for where home files will be placed
let os = (uname | get kernel-name)

let pubkey_file = match (uname | get kernel-name) {
  "Linux" => "/home/michael/.ssh/git_signing.pub"
  "Darwin" => "/Users/michael/.ssh/git_signing.pub"
  _ => "/tmp/git_signing.pub" # I don't expect this
}

# Get the key to see if changes are actually needed
let current_key = open $pubkey_file

let approved_file = (
    $env | get -o GIT_SIGNING_KEYS_FILE
    | if ($in | is-empty) {
        print -e "git-sign: GIT_SIGNING_KEYS_FILE not set"
        return
    } else { $in | path expand }
)

let agent_keys = (ssh-add -L | complete)

if $agent_keys.exit_code != 0 or ($agent_keys.stdout | str trim | is-empty) {
    print -e "git-sign: no keys in agent"
    return
}

let agent_key_parts = (
    $agent_keys.stdout
    | lines
    | each { |line| $line | split row ' ' | get 1 }
)

let approved_keys = (
    open $approved_file
    | lines
    | where { |line| not ($line | str starts-with '#') and not ($line | str trim | is-empty) }
)

let match = (
    $approved_keys
    | where { |key|
        let keypart = ($key | split row ' ' | get 1)
        $agent_key_parts | any { |k| $k == $keypart }
    }
    | first
)

if ($match | is-empty) {
    print -e "git-sign: no approved signing key found in agent — insert a YubiKey or load a key"
    return
}


if ($match == $current_key) {
  return
}

# Write the new key file
rm -f  $pubkey_file
$match | save $pubkey_file
