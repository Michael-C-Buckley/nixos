# My System Configuration

This flake is the major collection of all things I use to manage my systems.  It contains system and user profile configurations.

I previously had split up many of my flakes, but it was more difficult to manage instead of easier.  This is the rewrite recollecting them.

Caveat: I have included some custom options merged into the default Nix options namespace.  Copying small sections can incur breakage this way, especially from networking.

## Major Subsections

These sections include more detail Readme files in them.

* Clusters
* Home
* Hosts

### Clusters

Configurations for systems that are members of a defined cluster that share most of their settings.

### Home

My personal home configs, aka "dotfiles".  I have Hjem and Home-Manager compatible outputs.

### Hosts

Where my non-cluster systems are held, such as my desktop, laptop, a few servers.

## Credits & Thanks

TBD section where I will be thanking the people who made my Nix journey possible.
