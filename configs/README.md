# Configs & Config Paths

This is a mechanism for distinctly holding my raw configs for various things.
Nix is not the only consumer I intend to support, so this would allow an easier
way of referencing various components.

## Use in Nix

I created the attribute `configPaths` that contain this flake's configs directory.
There is also a function to split

This is useful for doing specific app overrides, though has some nuance on the usage:

```nix
# This will expose the entire directory 
"${configPath}/zsh/zshrc"

# This exposes the entire zsh directory
"${configPath.zsh}/zshrc"

# This evaluates to just the single file
configPath.zsh + "/zshrc"
```

Prefer the third in most use cases, as it is the most isolated.
