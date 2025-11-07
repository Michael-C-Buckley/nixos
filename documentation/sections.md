# Major Sections

Notable highlights from the project's structure. This is document is WIP.

## Clusters

Groups of servers integrated as a set with major configuration and operational overlap.

## Flake

Relating the flake-parts and dendritic usage. These are at the absolute top level and these options and settings exist everywhere, thanks to `import-tree`.

## Hosts

Configs for individual hosts (that aren't clusters). These include things like desktops, laptops, servers (including cloud VPS). More information about them can be found under the appropriate host folder.

## NixOS

These are nixos modules and are further broken into various categories.

### Minor Sections

#### .config

My tooling as it relates to the configuration.

#### Legacy

Things I am not using as part of the config, but moved for one reason or another. Either reference or a reminder to rewrite/design/integrate.
