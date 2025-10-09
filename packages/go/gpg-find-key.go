package main

import (
	"fmt"
	"os"
	"os/exec"
	"regexp"
	"strings"
)

func command(command string, args ...string) string {
	cmd := exec.Command(command, args...)
	output, err := cmd.CombinedOutput()
	if err != nil && os.Getenv("GOGPG_DEBUG") == "1" {
		fmt.Printf("Error: %v\n", err)
		return ""
	}
	return string(output)
}

type SubkeyInfo struct {
	Algorithm    string `json:"algorithm"`
	KeyID        string `json:"key_id"`
	Fingerprint  string `json:"fingerprint"`
	Capabilities string `json:"capabilities"`
	Presence     string `json:"presence"` // Presence is either the smart card SN or indicator on key stub status or not
}

func get_subkey_info() []SubkeyInfo {
	// Return found GPG subkey info in consumable format

	// Force each key onto a single line
	output := command("gpg", "--list-secret-keys", "--with-colons")
	output = strings.ReplaceAll(output, "\nfpr", "fpr")
	output = strings.ReplaceAll(output, "\ngrp", "grp")

	details_regex := regexp.MustCompile(`:{5}([\w]+){1,3}:{3}([\w#+\-]+):{1,5}(\w+):`)
	var signingKeys []SubkeyInfo

	for _, line := range strings.Split(output, "\n") {
		matches := details_regex.FindStringSubmatch(line)

		if len(matches) > 0 {
			// RSA keys show up as `23`, so swap them to be intelligible and grab the bit length
			if matches[3] == "23" {
				matches[3] = "rsa"

				bitLengthRegex := regexp.MustCompile(`ssb:u:(\d+):`)
				bitLengthMatch := bitLengthRegex.FindStringSubmatch(line)
				if len(bitLengthMatch) > 1 {
					matches[3] = fmt.Sprintf("rsa%s", bitLengthMatch[1])
				}
			}
			signingKeys = append(signingKeys, SubkeyInfo{
				Algorithm:    matches[3],
				KeyID:        "",
				Fingerprint:  regexp.MustCompile(`fpr:{9}([A-F0-9]{40}):`).FindStringSubmatch(line)[1],
				Capabilities: matches[1],
				Presence:     matches[2],
			})
		}
	}
	return signingKeys
}

func get_signing_keys(keys []SubkeyInfo) []SubkeyInfo {
	//
	var signingKeys []SubkeyInfo
	for _, key := range keys {
		if strings.Contains(key.Capabilities, "s") {
			signingKeys = append(signingKeys, key)
		}
	}
	return signingKeys
}

func find_best_algorithm(keys []SubkeyInfo) *SubkeyInfo {
	// Returns the best key based on algorithm preference
	// Preference order: [ed|cv]25519 > rsa > nistp
	// Returns nil if no signing key is found

	smart_card := get_card_serial()

	var bestKey *SubkeyInfo
	algorithmPreference := map[string]int{
		"25519": 3,
		"rsa":   2,
		"nistp": 1,
	}

	for _, key := range keys {
		if key.Presence != smart_card && len(key.Presence) > 2 && key.Presence != "TPM-Protected" && smart_card == "" {
			continue // Skip keys for cards not present
		}
		if strings.Contains(key.Capabilities, "s") { // Check if the key can sign
			if bestKey == nil || algorithmPreference[key.Algorithm] > algorithmPreference[bestKey.Algorithm] {
				bestKey = &key
			}
		}
	}
	return bestKey
}

func get_card_serial() string {
	// Return the card serial number if a card is present
	output := command("gpg-card", "--", "list")
	if output == "" {
		return ""
	}
	serial_regex := regexp.MustCompile(`Serial number[ \.]+: ([A-F0-9]+)`)
	matches := serial_regex.FindStringSubmatch(output)
	if len(matches) > 1 {
		return matches[1]
	}
	return ""
}

func main() {
	// Simply return a valid signing key from the card
	subkeys := get_subkey_info()
	signing_keys := get_signing_keys(subkeys)
	best_signing_key := find_best_algorithm(signing_keys)
	if best_signing_key != nil {
		fmt.Println(best_signing_key.Fingerprint)
	} else {
		os.Exit(1)
	}
}
