# These first set of languages have lots of duplication in their formatting
builtins.listToAttrs (map (a: {
  name = a;
  value = {format = "(via [$symbol($version )]($style))";};
}) (import ./langList.nix))
// {
  # The remaining languages do not duplication
  buf = {
    format = "(with [$symbol$version ]($style))";
  };

  c = {
    format = "(via [$symbol($version(-$name) )]($style))";
  };

  dotnet = {
    format = "(via [$symbol($version )(🎯 $tfm )]($style))";
  };

  elixir = {
    format = "(via [$symbol($version \\(OTP $otp_version\\) )]($style))";
  };

  ocaml = {
    format = "(via [$symbol($version )(\\($switch_indicator$switch_name\\) )]($style))";
  };

  package = {
    format = "(is [$symbol$version]($style) )";
  };

  python = {
    format = "(via [\${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style))";
  };

  raku = {
    format = "(via [$symbol($version-$vm_version )]($style))";
  };
}
