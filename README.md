# My System Configuration

This flake is the major collection of all things I use to manage my systems. It contains primary use systems, like desktop, laptop, and some servers.

I do have some things spun off like a few other servers, WSL, and secrets. Servers will be coming after some more flake-parts build-out on my part.

Caveat: I have included some custom options merged into the default Nix options namespace. Copying small sections can incur breakage this way, especially from networking (with advanced options since I am a network engineer). Private secrets are also in another repository (as a means to prevent harvest now, decrypt later).

## Major Frameworks

### Flake-Parts

This project makes fairly heavy use of flake-parts. It allows the leaner design I've recently

### [Hjem](https://github.com/feel-co/hjem)

Hjem is a NixOS module-based user home configuration framework. It is like Home-Manager in that it allows a user's home to be declared. It is different as it follows a much leaner approach. I prefer the higher performance, more reliable codebase and mechanisms, and lack of overly opinionated defaults in my configs. It does not provide modules but another project, [Hjem-Rum](https://github.com/snugnug/hjem-rum) does.

A small number are files are handled by simple recursive linker setup in `modules/user/findFiles.nix` that pulls and links all the files from `modules/user/files`. It rebuilds the nested folder structure in my `$HOME` exactly as-is. This is useful for anything that doesn't have a module without having to write declarative boilerplate.

### [NVF](https://github.com/notashelf/nvf)

NVF is a Neovim framework in Nix. It trivialized creating and maintaining a custom nvim setup. I never did traditional nvim configuration, and I don't think I ever will since this exists. My setup is standalone nested under `packages/nvf`. I ship a few variants depending on if its a basic config for servers or extensive for development hosts. They have similar UI but differing setups on language servers, mainly. I also have one variant for use with Vscode-Neovim plugin, which does work.

### Npins (Anticipated/upcoming)

I'll be moving some flake inputs to npins. The motivation is decreasing the amount of inputs and I'll be selecting inputs which do not depend on the flake metadata tree and no have inputs. The upside is increased performance from lazier evaluation and reduced dependency tree sizes, as well as not having to copy these sources to the nix store, even if they're not used.

## Credits & Thanks

A few people I would like to thank, though by no means an exhaustive list.

[Iynaix](https://github.com/iynaix/) - For various things including providing excellent examples for `repl.nix`, Impermanence, and ZFS, among other sane ideas like a format script over Disko

[Raf](https://github.com/notashelf/) - For endless Rafware (like NVF and Hjem, many others) and all the work maintaining quality software in the community

[TeamWolfya](https://github.com/teamwolfyta) - For helping me get onto Flake-parts and showing me all kinds of resources

[Vimjoyer](https://www.youtube.com/@vimjoyer) - For various simple videos that help get me started when I was still new, especially to Flakes

[Fazzi](https://gitlab.com/fazzi/nixohess) - For some quality Hjem examples that helped finally sort cursor and theming issues

[No Boilerplate](https://www.youtube.com/watch?v=CwfKlX3rA6E) - For the video that introduced me to NixOS and started this journey
