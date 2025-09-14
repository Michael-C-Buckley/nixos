# My System Configuration

This flake is the major collection of all things I use to manage my systems. It contains primray use systems, like desktop, laptop, and some servers.

I do have some things spun off like a few other servers, WSL, and secrets.

Caveat: I have included some custom options merged into the default Nix options namespace. Copying small sections can incur breakage this way, especially from networking (with advanced options since I am a network engineer). Private secrets are also in another repository (as a means to prevent harvest now, decrypt later).

### User configs

I currently have a simple recursive linker setup in `flake/user/findFiles.nix` that pulls and links all the files from `flake/user/files`. It rebuilds the nested folder structure in my `$HOME`.

This is an attempt at being declarative but also portable, as I intended to use this as the single-source of truth for dotfiles, even on nix-incompatible systems, like FreeBSD.

### Hosts

Where my non-cluster systems are held, such as my desktop, laptop, a few servers.

## Credits & Thanks

A few people I would like to thank, though by no means an exhaustive list.

[Iynaix](https://github.com/iynaix/) - For various things including providing excellent examples for `repl.nix`, Impermanence, and ZFS, among other sane ideas like a format script over Disko

[Raf](https://github.com/notashelf/) - For endless Rafware (like NVF and Hjem, many others) and all the work maintaining quality software in the community

[TeamWolfya](https://github.com/teamwolfyta) - For helping me get onto Flake-parts and showing me all kinds of resources

[Vimjoyer](https://www.youtube.com/@vimjoyer) - For various simple videos that help get me started when I was still new, especially to Flakes

[Fazzi](https://gitlab.com/fazzi/nixohess) - For some quality Hjem examples that helped finally sort cursor and theming issues

[No Boilerplate](https://www.youtube.com/watch?v=CwfKlX3rA6E) - For the video that introduced me to NixOS and started this journey
