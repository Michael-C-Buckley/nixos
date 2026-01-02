# Helix does not support language in the default config, so I've chosen to not
# wrap the config and instead use smfh, of which keep mutable with initial state
{config, ...}: {
  flake.hjemConfigs.helix = {pkgs, ...}: let
    mkMutable = name: body: {
      source = pkgs.writeText name body;
      type = "copy";
      permissions = "0644";
    };
  in {
    hjem.users.michael = {
      packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.helix];

      files = {
        ".config/helix/languages.toml" = mkMutable "helix-languages" ''
          [[language]]
          name = "nix"
          auto-format = true
          formatter = {command = "alejandra"}
        '';

        ".config/helix/config.toml" = mkMutable "helix-config" ''
          theme = "ayu_dark"

          [editor]
          line-number = "relative"

          [editor.cursor-shape]
          insert = "bar"
          normal = "block"
          select = "underline"

          [editor.file-picker]
          hidden = false
        '';
      };
    };
  };
}
