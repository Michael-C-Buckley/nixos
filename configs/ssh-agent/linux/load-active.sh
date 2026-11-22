#!/usr/bin/env bash

# writeShellApplication supplies Bash strict mode and a pinned OpenSSH PATH.
# A service has no terminal: encrypted files can be added manually with ssh-add.
export SSH_ASKPASS_REQUIRE=never

# ExecStartPost can run before ssh-agent has bound its socket. An empty agent
# returns 1; only 2 means the agent cannot yet be contacted.
for ((attempt = 0; attempt < 50; attempt++)); do
	status=0
	ssh-add -l >/dev/null 2>&1 || status=$?
	if ((status != 2)); then
		break
	fi
	sleep 0.1
done
if ((status == 2)); then
	echo "Could not contact OpenSSH agent at $SSH_AUTH_SOCK" >&2
	exit 1
fi

shopt -s nullglob dotglob
for key in "$HOME/.ssh/active/"*; do
	[[ -f "$key" && -r "$key" ]] || continue
	case "$key" in
	*.pub) continue ;;
	esac

	# Do not assume a filename: ssh-keygen -K downloads resident-key handles
	# with variable names. Ignore public keys and unrelated files by content.
	header=""
	IFS= read -r header <"$key" || true
	case "$header" in
	"-----BEGIN OPENSSH PRIVATE KEY-----" | \
		"-----BEGIN RSA PRIVATE KEY-----" | \
		"-----BEGIN EC PRIVATE KEY-----" | \
		"-----BEGIN DSA PRIVATE KEY-----" | \
		"-----BEGIN PRIVATE KEY-----" | \
		"-----BEGIN ENCRYPTED PRIVATE KEY-----") ;;
	*) continue ;;
	esac

	# One bad or encrypted file must not prevent the other keys from loading.
	if ! ssh-add -q "$key" </dev/null; then
		echo "Could not auto-load $key; try ssh-add manually if it needs a passphrase" >&2
	fi
done
