#!/bin/sh
set -eu

# Read-only HTTPS credentials with repository, owner, then host precedence.
# The encrypted document lives in the user's Git config directory.
# Identities are always machine-local, even with a custom XDG_CONFIG_HOME.
credential_file="${XDG_CONFIG_HOME:-$HOME/.config}/git/credentials.enc.json"
operation=${1:-}

fail() {
	printf 'git-credential-sops: %s\n' "$*" >&2
	if [ "$operation" = explain ]; then
		exit 1
	fi
	# This is a credential-protocol refusal: stop fallback helpers and prompts.
	printf 'quit=true\n\n'
	exit 0
}

owner_mode() {
	# GNU stat is supplied by Nix; also accept BSD stat on macOS.
	stat -c '%u:%a' -- "$1" 2>/dev/null || stat -f '%u:%Lp' "$1" 2>/dev/null
}

init_cache() {
	cache_uid=$(id -u)
	cache_dir="/tmp/git-credential-sops-$cache_uid"
	umask 077
	mkdir -m 700 -- "$cache_dir" 2>/dev/null || true
	if [ ! -d "$cache_dir" ] || [ -L "$cache_dir" ] ||
		[ "$(owner_mode "$cache_dir")" != "$cache_uid:700" ]; then
		fail "unsafe credential cache directory: $cache_dir"
	fi
}

credential_response() {
	# Validate before emitting anything. Never allow control characters to
	# inject additional protocol fields, or use another account's username.
	jq -er --arg username "$username" '
		select(type == "object")
		| select(.username | type == "string")
		| select(.token | type == "string")
		| select(.username | length > 0)
		| select(.token | length > 0)
		| select(.username | test("[[:cntrl:]]") | not)
		| select(.token | test("[[:cntrl:]]") | not)
		| select($username == "" or $username == .username)
		| "username=\(.username)\npassword=\(.token)"
	' "$1" 2>/dev/null
}

case $operation in
get | erase | explain) ;;
store)
	# Provisioning and rotation happen through SOPS, never through Git.
	cat >/dev/null
	exit 0
	;;
clear)
	init_cache
	rm -f -- "$cache_dir"/*.json "$cache_dir"/*.tmp.*
	printf 'Cleared Git credential cache.\n'
	exit 0
	;;
-h | --help)
	printf '%s\n' \
		"Git HTTPS credential helper backed by $credential_file." \
		'Matches repository overrides, then owners, then the host default.' \
		'Uses ~/.config/keys/age/tpm.key, falling back to ~/.config/sops/age/tpm.key.' \
		'Keeps decrypted credentials in a protected per-user /tmp cache.' \
		'Run git-credential-sops explain [--file FILE] HTTPS_URL to inspect routing without decrypting.' \
		'Run git-credential-sops clear to remove cached credentials.'
	exit 0
	;;
*) exit 0 ;;
esac

protocol=
host=
repository=
username=
seen_protocol=0
seen_host=0
seen_path=0
seen_username=0
if [ "$operation" = explain ]; then
	shift
	if [ "${1:-}" = --file ]; then
		[ "$#" -eq 3 ] || fail 'usage: explain [--file FILE] HTTPS_URL'
		credential_file=$2
		shift 2
	fi
	[ "$#" -eq 1 ] || fail 'usage: explain [--file FILE] HTTPS_URL'
	case $1 in
	https://*)
		protocol=https
		url=${1#https://}
		host=${url%%/*}
		if [ "$url" != "$host" ]; then
			repository=${url#*/}
		fi
		;;
	*) fail 'explain requires an HTTPS URL' ;;
	esac
else
	while IFS= read -r line || [ -n "$line" ]; do
		[ -n "$line" ] || break
		case $line in
		protocol=*)
			[ "$seen_protocol" -eq 0 ] || fail 'duplicate protocol in credential request'
			protocol=${line#protocol=}
			seen_protocol=1
			;;
		host=*)
			[ "$seen_host" -eq 0 ] || fail 'duplicate host in credential request'
			host=${line#host=}
			seen_host=1
			;;
		path=*)
			[ "$seen_path" -eq 0 ] || fail 'duplicate path in credential request'
			repository=${line#path=}
			seen_path=1
			;;
		username=*)
			[ "$seen_username" -eq 0 ] || fail 'duplicate username in credential request'
			username=${line#username=}
			seen_username=1
			;;
		esac
	done
fi

[ "$protocol" = https ] || fail 'credentials are available only over HTTPS'
case $host in
'' | *[!a-zA-Z0-9.:-]*) fail 'missing or invalid forge hostname' ;;
esac
host=$(printf '%s' "$host" | tr '[:upper:]' '[:lower:]')
host=${host%:443}

owner=
if [ -n "$repository" ]; then
	# GitHub-style forge names are case insensitive. Match the full relative
	# repository path, with one optional trailing slash and .git suffix.
	case $repository in
	*[!a-zA-Z0-9._/-]*) fail 'invalid repository path' ;;
	esac
	repository=$(printf '%s' "$repository" | tr '[:upper:]' '[:lower:]')
	repository=${repository%/}
	repository=${repository%.git}
	case /$repository/ in
	*//* | */./* | */../*) fail 'invalid repository path' ;;
	esac
	case $repository in
	*/*) owner=${repository%%/*} ;;
	esac
fi

[ -f "$credential_file" ] || fail "encrypted credentials not found: $credential_file"
# Match visible JSON keys only. Selecting an explicit entry commits to that
# scope: an empty, invalid, or rejected token never tries a broader credential.
if ! selection=$(jq -ce --arg host "$host" --arg repository "$repository" --arg owner "$owner" '
	def scope_map($entry; $name):
		if $entry | has($name) then
			$entry[$name] | if type == "object" then . else error("invalid scope map") end
		else {} end;
	def matching_key($entries; $name):
		[$entries | keys[] | select(ascii_downcase == $name)]
		| if length > 1 then error("ambiguous scope names") else .[0] end;
	. as $document
	| if type != "object" then error("invalid document")
	  elif .sops == null then error("missing SOPS metadata")
	  else . end
	| .[$host] as $forge
	| if $forge == null then {scope: "none", path: []}
	  elif ($forge | type) != "object" then error("invalid host entry")
	  else
		scope_map($forge; "repositories") as $repositories
		| scope_map($forge; "owners") as $owners
		| if $repository == "" and (($repositories | length) + ($owners | length) > 0) then
			{scope: "path-required", path: []}
		  else
			matching_key($repositories; $repository) as $repo_key
			| matching_key($owners; $owner) as $owner_key
			| if $repository != "" and $repo_key != null then
				{scope: "repository", path: [$host, "repositories", $repo_key]}
			  elif $owner != "" and $owner_key != null then
				{scope: "owner", path: [$host, "owners", $owner_key]}
			  elif $forge | has("token") then
				{scope: "host", path: [$host]}
			  else {scope: "none", path: []} end
		  end
	  end
	| . as $match
	| . + {encrypted: (
		if .scope == "none" or .scope == "path-required" then false
		else ($document | getpath($match.path)) as $entry
			| if ($entry | type) != "object" then false
			  else $entry.token | if type == "string" then startswith("ENC[") else false end
			  end
		end
	)}
' "$credential_file" 2>/dev/null); then
	fail "invalid credential routing for $host; scope maps must be objects with unambiguous names"
fi

scope=$(printf '%s' "$selection" | jq -r '.scope')
case $scope in
path-required) fail 'repository path required; enable credential.useHttpPath' ;;
none) fail "no credential configured for $host${repository:+/$repository}" ;;
esac
selector=$(printf '%s' "$selection" | jq -r '.path | map("[" + tojson + "]") | join("")')
if [ "$operation" = explain ]; then
	printf 'Source: %s\nRequest: https://%s%s\nScope: %s\nEntry: %s\n' \
		"$credential_file" "$host" "${repository:+/$repository}" "$scope" "$selector"
	if ! printf '%s' "$selection" | jq -e '.encrypted' >/dev/null; then
		fail 'selected entry has no encrypted read-only token'
	fi
	printf 'Status: encrypted token configured; decryption and forge permissions not checked.\n'
	exit 0
fi

init_cache
# Retire the former host-only cache filename when this host is next used.
rm -f -- "$cache_dir/$host.json"
selector_hash=$(printf '%s' "$selector" | sha256sum)
cache_key="$host.${selector_hash%% *}"
cache_file="$cache_dir/$cache_key.json"
if [ "$operation" = erase ]; then
	# Invalidate only the selected scope; unrelated owner/repository caches stay.
	rm -f -- "$cache_file"
	exit 0
fi
if ! printf '%s' "$selection" | jq -e '.encrypted' >/dev/null; then
	rm -f -- "$cache_file"
	fail "selected $scope entry $selector has no encrypted read-only token"
fi

# Hashing the small encrypted document avoids hardware access on warm fetches, and
# invalidates cached plaintext immediately when tokens or recipients change.
source_hash=$(sha256sum <"$credential_file")
source_hash=${source_hash%% *}
if [ -e "$cache_file" ] || [ -L "$cache_file" ]; then
	if [ ! -f "$cache_file" ] || [ -L "$cache_file" ] ||
		[ "$(owner_mode "$cache_file")" != "$cache_uid:600" ]; then
		fail "unsafe cached credential for $scope entry $selector"
	fi
	if jq -e --arg source_hash "$source_hash" '._source_hash == $source_hash' \
		"$cache_file" >/dev/null 2>&1; then
		if ! response=$(credential_response "$cache_file"); then
			fail "invalid cached credential or mismatched username for $scope entry $selector"
		fi
		printf '%s\n\n' "$response"
		exit 0
	fi
fi
rm -f -- "$cache_file"

plain_file=
cache_stage=
cleanup() {
	if [ -n "$plain_file" ]; then
		rm -f -- "$plain_file"
	fi
	if [ -n "$cache_stage" ]; then
		rm -f -- "$cache_stage"
	fi
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

# Stage plaintext privately; only publish a complete, validated cache entry.
plain_file=$(mktemp "$cache_dir/$cache_key.tmp.XXXXXX") || fail 'could not create protected temporary credential file'

# SOPS also discovers keys.txt and SSH identities independently of
# SOPS_AGE_KEY_FILE. Hide those defaults and unset ambient key commands so
# routine fetches use only the designated identities, never recovery YubiKeys.
# Prefer the new path; retain the old path while hosts migrate. Bound plugin
# failures per identity, close stdin, and decrypt into the protected file.
decrypted=0
for identity_file in "$HOME/.config/keys/age/tpm.key" "$HOME/.config/sops/age/tpm.key"; do
	[ -r "$identity_file" ] || continue
	if timeout 15s env \
		-u SOPS_AGE_KEY -u SOPS_AGE_KEY_CMD \
		-u SOPS_AGE_SSH_PRIVATE_KEY_CMD -u AGE_TPM_PIN \
		HOME=/var/empty XDG_CONFIG_HOME=/var/empty \
		SOPS_AGE_KEY_FILE="$identity_file" \
		SOPS_AGE_SSH_PRIVATE_KEY_FILE=/dev/null \
		sops decrypt --extract "$selector" --output-type json "$credential_file" \
		>"$plain_file" </dev/null 2>/dev/null; then
		decrypted=1
		break
	fi
done
[ "$decrypted" -eq 1 ] || fail "could not decrypt $scope entry $selector with ~/.config/keys/age/tpm.key or ~/.config/sops/age/tpm.key"

if ! response=$(credential_response "$plain_file"); then
	fail "invalid credential or mismatched username for $scope entry $selector"
fi

cache_stage=$(mktemp "$cache_dir/$cache_key.tmp.XXXXXX") || fail 'could not stage credential cache'
if ! jq --arg source_hash "$source_hash" '{ username, token, expires_on, _source_hash: $source_hash }' \
	"$plain_file" >"$cache_stage" 2>/dev/null; then
	fail "could not prepare cached credential for $host"
fi
mv -f -- "$cache_stage" "$cache_file" || fail "could not save cached credential for $host"
cache_stage=
printf '%s\n\n' "$response"
