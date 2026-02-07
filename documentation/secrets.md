# Secrets Management

This is a big topic and there's a lot of ways to do it, however this is what I currently do.
It is a mix of a several techniques that all together secure my footprint.

Information here includes secrets in a nix config, but also others, such as securing secrets on the running systems as well.

## Yubikey

This is the single largest impact I personally find for secrets.
All important keys are now held in hardware, portable, bu also non-extractable.
My downstream decisions on structure for various things revolve largely around identities provided from these devices.

### Age, not GPG

I use [age](https://github.com/FiloSottile/age), not [gnupg](https://gnupg.org/) because of their [failures](https://gpg.fail/).
Previously I had used GPG but completely migrated after the GPG fail exposure.

My yubikeys contains age keys via [age-plugin-yubikey](https://github.com/str4d/age-plugin-yubikey).
Hosts will contain either an age key file or use their SSH host key files.

Yubikeys have master keys that can decrypt all my sops-nix secrets.
Hosts have secrets keyed for their keys.

This is not yet automated deployments, thus the `.sops.yaml` I have is huge, but will eventually (and write about it when I do).

### FIDO2

The main applet of choice, after hitching GPG.
It provides webauthn passkeys and SSH keys.

I use a combo of resident and non-resident keys, depending on what my needs are.
Non-resident key stubs are for personal machines, while resident keys are convenient when on foreign systems.

Additionally, I use PAM with RSSH to provide yubikey-secured passwordless sudo.
This feature is available even on remote hosts since SSH agents provide the PAM and can be easily forwarded.
I do not use U2F PAM and only RSSH, it provides a singular experience on local or remote hosts tied to the currently connected yubikey and way less management needed.

## [Sops-nix](https://github.com/Mic92/sops-nix)

I use the systemd service unit, for why see below.
Sops-nix versus Agenix is often contested, and not something I find meaningfully different for most users.
It boils down to a few particulars most often, and one or two features (or not having anti-features, from the POV of the user).

I use Sops-nix because:

- Tool I already know (Sops)
- Sops is CNCF (currently at the sandbox level)
- Supports Templating

Which covers most bases. It's a good tool, lots of support in a rich ecosystem, something I know and Sops-nix has a feature I want: Templating.
This is useful in particular for when doing secrets with kubernetes deployments, as you can template them in when using environment variables or opaque secrets are not possible.

Actual bodies of encrypted secretes are held in a private repository.

## Private Repository

My actual secret information (even encrypted) is stored in a private repository.
The reason is simple: [Harvest now, decrypt later](https://en.wikipedia.org/wiki/Harvest_now,_decrypt_later).
Much of the information is not particularly sensitive, but it is just cautionary.
I already have an extremely large amount of metadata about my systems available.
This is an attempt to slightly staunch that and prevent issues from unknown vectors.

I do not intend to make my flake private, as I want it to be a resource for the community.
Howveer, exposure of secrets is not required there, so I will not.
Public resources have done me a lot of good and I wish to add to that.
Including talking about various aspects of my security, even if others would not consider that best practice.

## [Systemd-Credentials](https://systemd.io/CREDENTIALS/)

The dark horse in this one is systemd-credentials.
It allows you to seal secrets with the local TPM and also only unseal for selected service units.

I use this to seal key files so they are not exposed on the filesystem.
They are only given to the authorized service units like SSH server and Sops decryption.

Unlike sops-nix, it is imperative.
I find this acceptable as the main items held in it are not declared and are ephemeral and replaceable components of identity.
Additionally, the secrets can involved the TPM and various PCR as well.
I currently use secure boot so I use PCR 7 on my secrets as well, which requires a valid secure boot state to decrypt.

## Drive Encryption

I do use some drive encryption, such as on my laptop.
ZFS is the only filesystem I use, so ZFS native encryption is used.
Between secure boot, encryption and yubikeys, most of the threats are highly mitigated.
