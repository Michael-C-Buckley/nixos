#!/usr/bin/env bash
# Point a systemd-boot Type #1 entry at the UKI of the current system profile.
#
# Usage: lanzaboote-latest-entry ESP NAMESPACE TITLE SORT_KEY [PROFILE]
#
# The ESP is FAT, so a symlink cannot be used. Instead the entry chainloads the
# signed Lanzaboote UKI through the `efi` key. Failures only warn: the
# generations themselves are already installed, and this entry is a shortcut.

esp=$1
namespace=$2
title=$3
sort_key=$4
profile=${5:-/nix/var/nix/profiles/system}

entries="$esp/loader/entries"
entry="$entries/$namespace-latest.conf"

warn() {
  echo "lanzaboote-latest-entry: $*; leaving $entry unchanged." >&2
  exit 0
}

# Use the generation the profile points at, not the highest number on the
# ESP, so a rollback moves the shortcut back as well.
link=$(readlink "$profile") || warn "cannot read $profile"
generation=${link#system-}
generation=${generation%-link}
case $generation in
  '' | *[!0-9]*) warn "cannot parse a generation from $profile -> $link" ;;
esac

shopt -s nullglob
ukis=()
for uki in "$esp/EFI/Linux/$namespace-generation-$generation-"*.efi; do
  case ${uki##*/} in
    *-specialisation-*) ;;
    *) ukis+=("$uki") ;;
  esac
done
((${#ukis[@]} == 1)) ||
  warn "expected one UKI for $namespace generation $generation, found ${#ukis[@]}"

mkdir -p "$entries"
# systemd-boot only reads *.conf, so the temporary file is never listed.
tmp="$entries/.$namespace-latest.conf.tmp"
printf 'title %s\nversion generation %s\nsort-key %s\nefi /EFI/Linux/%s\n' \
  "$title" "$generation" "$sort_key" "${ukis[0]##*/}" >"$tmp"
sync "$tmp"
mv -f "$tmp" "$entry"
sync "$entries"
echo "lanzaboote-latest-entry: $entry -> ${ukis[0]##*/}"
