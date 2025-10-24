{
  perSystem = {pkgs, ...}: {
    # Fetch from Github since the last commit for this repo was 4 years ago at time of writing
    packages.citylights-nvim = pkgs.vimUtils.buildVimPlugin {
      pname = "citylights.nvim";
      version = "b1a3b6979053bb73f81ea481a004c24986421b46"; # or use a commit hash/date
      src = pkgs.fetchFromGitHub {
        owner = "michael-c-buckley";
        repo = "citylights.nvim";
        rev = "b1a3b6979053bb73f81ea481a004c24986421b46"; # replace with the desired commit
        sha256 = "sha256-E4N0WMnIJGQVHh8NW+/4drGmQVYcdYDVK8zLGFpFcfE="; # replace with the correct hash
      };
    };
  };
}
