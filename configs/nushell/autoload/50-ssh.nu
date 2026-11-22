# ── SSH ──────────────────────────────────────────────────────────────────────

# List concrete aliases from the main SSH config and config.d snippets
def ssh-config-hosts [] {
    let config_files = (
        [($nu.home-dir | path join ".ssh/config")]
        | append (glob ($nu.home-dir | path join ".ssh/config.d/*.conf"))
        | append (glob ($nu.home-dir | path join ".orbstack/ssh/config"))
    )

    $config_files
    | where { |file| $file | path exists }
    | each { |file| open --raw $file | lines }
    | flatten
    | where { |line| $line =~ "(?i)^\\s*Host\\s+" }
    | each { |line|
        $line
        | str replace --regex "(?i)^\\s*Host\\s+" ""
        | str replace --regex "\\s+#.*$" ""
        | split row --regex "\\s+"
      }
    | flatten
    | where { |host| $host !~ "[*!?]" }
    | uniq
    | sort
}

# Pick a configured SSH host with fzf. Arguments are passed as SSH options.
def --wrapped sshf [...args: string] {
    if (which fzf | is-empty) {
        error make { msg: "sshf: fzf is not installed" }
    }

    let host = try {
        ssh-config-hosts
        | str join (char nl)
        | ^fzf --height 40% --reverse --prompt "ssh> "
        | str trim
    } catch { "" }

    if $host != "" {
        ^ssh ...$args $host
    }
}
