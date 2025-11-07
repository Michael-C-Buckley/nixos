# Design Intent (Still WIP)

This is my primary Nix & NixOS flake. It contains configs for my various hosts as well as other elements like some packages.

## Major Design Elements

- Flakes
- Dendritic Pattern
- Hjem
- NVF

## Dendritic Nix

This is the most fundamental structural component of my entire flake. All nix files (with rare exception) are flake-parts modules and imported automatically.

All modules are no longer constrained by their physical file location path, which is the chief element I was after using this pattern.

I was able to better compose my configurations once that limitation was removed, especially since I group things by category and compose them far away from the physical location.

## Flakes

Flakes, Flake-Parts, and Dendritic Nix are the overwhelming reason I am able to so freely compose my nix as I do. As such, flake-primary thinking will be consistent in this repository.

While not perfect, they are suitable. I am considering npins but only in addition to flakes, not as a replacement. They would cover things that do not have shared or manipulated inputs and typically ancillary things.

## Shell.nix

Despite being flake primary, not all elements are flakes. The nix shell (and direnv for it) are a traditional nix shell. I do not feel the need to strict locking of the dependencies (and the fuss that can come with that) for a few basic tools that can be "reasonably" fresh. Nix-direnv takes care of caching.

Likewise, I am not living elements of pre-commit within `flake.nix` or its inputs. I use a more traditional approach via `shell.nix` triggered by `direnv` and various tools configured in `.config`. Linting, formatting, etc need not be transferred to other projects as strict dependencies, when they have no bearing on the operational nature of the flake's modules.

By this logic, I deleted non-operational inputs from my inputs. This weakens the dependency graph as much as possible.

### What I Utilize

- Categorical Groupings

Dendritic Nix allows freedom on file locations, so I have granularly separated out components and grouped them, such as hosts, or modules like apps or user configs.

- Minimal Logic

Most of my modules have no logic in them. They are entirely pluggable as a single component. Previously, I had quite a lot of conditional logic with custom options for everything. I realize that I was creating and maintaining them and *never using them*. The dendritic restructuring allowed me to eliminate almost all of it.

- Composable Presets

My shared modules are tiered and "factored" out. They are a logical grouping of modules (and occasional settings). Some presets include other presets in them.

### What I Do Not Intend

- Verbose, Nested, or Deep Abstractions

The chief limitation of module pathing was the my main desire. Some dendritic users are exploring the limitations of what is possible. I am not, I do not wish to make my already complex config any worse in complexity.

- Nested or Derivative Frameworks

I am a very large framework skeptic. My adoption of Flake-Parts, as a software framework, and Dendritic, as a design framework, were after careful consideration.

Flake-Parts is well-composed, supports, and adopted. I do not have concerns about it not being maintained six months from now.

I currently am not interested in subframeworks for either of the components.
