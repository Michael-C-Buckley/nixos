# ── direnv ───────────────────────────────────────────────────────────────────
# Loads and unloads .envrc on every directory change. The hook is marked so
# that loading this file twice doesn't run direnv twice.

use std/config env-conversions

$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [])

if not ($env.config.hooks.env_change.PWD | any {|hook| ($hook | describe) starts-with "record" and ($hook.__direnv_hook? | default false) }) {
    $env.config.hooks.env_change.PWD ++= [{
        __direnv_hook: true
        code: {||
            if (which direnv | is-empty) {
                return
            }

            direnv export json | from json | default {} | load-env
            # direnv sets PATH as a string, so convert it back to a list
            if ($env.PATH | describe) == "string" {
                $env.PATH = do (env-conversions).path.from_string $env.PATH
            }
        }
    }]
}
