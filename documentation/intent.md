# Design Intent

This is my primary Nix & NixOS flake.
It contains configs for my various hosts as well as other elements like some packages.

## Major Design Elements

- Flakes
- Dendritic Pattern
- Hjem
- NVF

## Dendritic Nix

This is the most fundamental structural component of my entire flake.
All nix files (with rare exception) are flake-parts modules and imported automatically.

All modules are no longer constrained by their physical file location path, which is the chief element I was after using this pattern.

I was able to better compose my configurations once that limitation was removed, especially since I group things by category and compose them far away from the physical location.
What this means is my imports are no longer `./../../some/path.nix` but instead now `flake.modules.nixos.something` instead.
Module imports reference the namespace that I assign and are totally free from having to walk up and down a filepath tree.

Other features exist too, such as

## Flakes

Flakes, Flake-Parts, and Dendritic Nix are the overwhelming reason I am able to so freely compose my nix as I do.
As such, flake-primary thinking will be consistent in this repository.

While not perfect, they are suitable.
I use additional fetchers and dependency management but only in addition to flakes, not as a replacement.
They would cover things that do not have shared or manipulated inputs and typically ancillary things.
Covered in more detail below.

## Shell.nix

Despite being flake primary, not all elements are flakes.
The nix shell (and direnv for it) are a traditional nix shell.
I do not feel the need to strict locking of the dependencies (and the fuss that can come with that) for a few basic tools that can be "reasonably" fresh.
Nix-direnv takes care of caching.

Likewise, I am not living elements of pre-commit within `flake.nix` or its inputs.
I use a more traditional approach via `shell.nix` triggered by `direnv` and various tools configured in `.config`. Linting, formatting, etc need not be transferred to other projects as strict dependencies, when they have no bearing on the operational nature of the flake's modules.

By this logic, I deleted non-operational inputs from my inputs.
This weakens the dependency graph as much as possible.

## Additional Fetchers

I have Npins and Nvfetcher in my project.
They are used to fetch github repos and appImages, respectively.

Nvfetcher gets appImages which is only helium browser for now, since I package that individually.

Npins is mainly used to not aggressively grow the flake dependency graph.
It provides two features: truly lazy evaluations and not input chaining.
I accomplish my goals with it by directly importing or calling target modules from the npinned item.
This does slightly increase code complexity, but keeps a large scale flake such as this extremely performant.k
My eval times are lower than most peoples despite have added overhead from flake-parts and dendritic.

These are somewhat advanced topics and I recommend sticking with flakes for most needs unless someone knows exactly how and why not to.
Flakes succeed at standardizing inputs and outputs and at least do those parts well.

### What I Utilize

- **Categorical Groupings**

Dendritic Nix allows freedom on file locations, so I have granularly separated out components and grouped them, such as hosts, or modules like apps or user configs.

- **Minimal Logic**

Most of my modules have no logic in them.
They are entirely pluggable as a single component.
Previously, I had quite a lot of conditional logic with custom options for everything.
I realize that I was creating and maintaining them and *never using them*.
The dendritic restructuring allowed me to eliminate almost all of it.

- **Composable Presets**

My shared modules are tiered and "factored" out.
They are a logical grouping of modules (and occasional settings). Some presets include other presets in them.

They are literally the `preset` family of modules, which are nixos modules composed of other nixos modules.
The end hosts can import a module of a present type and immediately gain all the components without having to relist them all.

### What I Do Not Intend

- **Verbose, Nested, or Deep Abstractions**

The chief limitation of module pathing was the my main desire.
Some dendritic users are exploring the limitations of what is possible.
I am not, I do not wish to make my already complex config any worse in complexity.

Likewise, I do not usually use overlays and I do not alias modules names.
Three's enough complexity for anyone looking at various sections to easily get lost without additional inexplicit behavior.

- **Nested or Derivative Frameworks**

I am a very large framework skeptic. My adoption of Flake-Parts, as a software framework, and Dendritic, as a design framework, were after careful consideration.
Flake-Parts is well-composed, supported, and adopted. I do not have concerns about it not being maintained six months from now.
I currently am not interested in subframeworks for either of the components.

Despite being dendritic, I do not use `import-tree` which is the most common dendritic-accessory and fundamental lynchpin of the pattern.
Instead, I created my own implementation [here](https://github.com/Michael-C-Buckley/nixos/blob/master/flake.nix#L14).
It effectively replicates the behavior I need without an external dependency.
