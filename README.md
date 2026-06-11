# My System Configuration

> [!NOTE]
> This project has been archived.
> My flake is being handled privately, and for a few core reasons.
> I made my system public in the first place as a way to give back to the community, I had a chance to learn so much from other's works.
> However, I'm being limited in a few aspects which has made me close it, for now.
> It mainly has to do with security and due diligence in an era where exploits and challenges are rising steadily.
> To all those who helped me get here, thank you.
> To those who show up after, I think there may be a few things worth learning from still.

This flake is the major collection of all things I use to manage my systems.
It contains primary use systems, like desktop, laptop, and some servers.

Caveat: I have included some custom options merged into the default Nix options namespace.
Copying small sections can incur breakage this way, especially from networking (with advanced options since I am a network engineer).
Secrets are protected by sops-nix and deployed manually on the hosts, using absolute paths (as a means to prevent harvest now, decrypt later).

## Major Frameworks

### Semi-[Dendritic](https://vic.github.io/dendrix/Dendritic.html) Inspiration

The flake has a partial implementation of the dendritic pattern.
The divergence is that the nixos modules are collected via a custom import-tree lookalike.
However, flake-parts is not used.
The module imports are collected by name and added to via the nixosModules flake output.

### [Hjem](https://github.com/feel-co/hjem)

Hjem is a NixOS module-based user home configuration framework.
It is like Home-Manager in that it allows a user's home to be declared.
It is different as it follows a much leaner approach. I prefer the higher performance, more reliable codebase and mechanisms, and lack of overly opinionated defaults in my configs.
It does not provide modules but another project, [Hjem-Rum](https://github.com/snugnug/hjem-rum) does (although I do not use this).

### Non-Flake Inputs (Nvfetcher & Npins)

I am using Nvfetcher to get appImages and npins for other non-flake items.
The motivation is decreasing the amount of inputs and I'll be selecting inputs which do not depend on the flake metadata tree and no have inputs.
The upside is increased performance from lazier evaluation and reduced dependency tree sizes, as well as not having to copy these sources to the nix store, even if they're not used.

### Wrappers & BuildEnv

INFO: Wrappers are being converted after a recent major change that removed flake-parts.

Nix provides a unique opportunity for "wrapping" packages.
This allows a package derivation to be created that provides additional package paths and other things, like pre-bundling configuration files.
I have created a number of wrapped packages under `packages/wrapped` which contain my application "experiences" with their configs and dependencies.

Additionally, nixpkgs provides `pkgs.buildEnv` which allows you to create 1 package derivation with multiple packages in it.
As such, I've decided to move a number of standalone wrapped packages to various buildEnv definitions.
This creates the ability to manage those items independently from the system and home-manager, via nix profile.

This is a highly explicit choice, and still somewhat new to my process.
What it provides is the ability to not couple small items like shell config tweaks to requiring system rebuilds or additional frameworks like home-manager.
Useful in the case of servers where I want CLI tools available, and updatable, but without disturbing the rest of the system for tweaks and having a fully declared experience.

### Other Related Projects

#### [NVF](https://github.com/notashelf/nvf)

NVF is a Neovim framework in Nix.
It trivialized creating and maintaining a custom nvim setup.
This is how I started my nvim journey, though I've transitioned (to the next section).

My setup is standalone and can be found here: [nvf-flake](https://github.com/Michael-C-Buckley/nvf-flake)

#### Nvim

I also use [mnw](https://gerg-l.github.io/mnw/) to create a more traditional config.
This is the current way I'm using nvim.
It uses nix to manage and build the package with configs kept in traditional lua.

My flake is [here](https://github.com/michael-c-buckley/nvim.nix)

## Credits & Thanks

A few people I would like to thank, though by no means an exhaustive list.

[Iynaix](https://github.com/iynaix/) - For various things including providing excellent examples for `repl.nix`, Impermanence, and ZFS, among other sane ideas like a format script over Disko

[Raf](https://github.com/notashelf/) - For endless Rafware (like NVF and Hjem, many others) and all the work maintaining quality software in the community

[TeamWolfya](https://github.com/teamwolfyta) - For helping me get onto Flake-parts and showing me all kinds of resources

[Vimjoyer](https://www.youtube.com/@vimjoyer) - For various simple videos that help get me started when I was still new, especially to Flakes

[Fazzi](https://gitlab.com/fazzi/nixohess) - For some quality Hjem examples that helped finally sort cursor and theming issues

[No Boilerplate](https://www.youtube.com/watch?v=CwfKlX3rA6E) - For the video that introduced me to NixOS and started this journey
