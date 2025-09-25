#!/usr/bin/env bash
KEYS=(
    "483864BF916E149C4F57E2371A0163427F977C33"
    "6F749AA097DC10EA46FE0ECD22CDD3676227046"
    "095072D6264D656F8B58788FACFBE5782107D674"
    "80855EFEC0ADD549E3AEE956598FE4ECFF808273"
)

KEY_TYPES=(
    "Ed25519"
    "Ed25519" 
    "Ed25519"
    "RSA2048"
)

echo "Checking for available GPG keys..."

# Find first working key
for i in "${!KEYS[@]}"; do
    key="${KEYS[$i]}"
    key_type="${KEY_TYPES[$i]}"
    
    # Check if key exists
    if ! gpg --list-secret-keys "$key" >/dev/null 2>&1; then
        continue
    fi
    
    if [[ $i -eq 3 ]]; then
        if echo "test" | gpg --digest-algo SHA256 --default-key "$key" --clearsign >/dev/null 2>&1; then
            echo " Using $key_type - SHA256 ($key)"
            git config user.signingkey "$key"!
            git config gpg.program gpg256 
            exit 0
        fi
    else
        if echo "test" | gpg --default-key "$key" --clearsign >/dev/null 2>&1; then
            echo " Using $key_type - SHA512 ($key)"
            git config user.signingkey "$key"!
            exit 0
        fi
    fi
done

echo "❌ No GPG keys available"
exit 1
