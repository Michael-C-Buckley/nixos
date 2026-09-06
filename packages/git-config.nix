{
  pkgs,
  name ? "Michael Buckley",
  email ? "michaelcbuckley@proton.me",
  signingkey ? "~/.ssh/active/signingKey",
  editor ? "vim",
  sign ? true,
  extraIgnores ? [ ],
  ...
}:
let
  # A helpful personal global ignore
  ignores = [
    ".DS_Store"
    ".AppleDouble"
    ".LSOverride"
    "Icon"
    ".direnv"
    "._*"
    ".DocumentRevisions-V100"
    ".fseventsd"
    ".Spotlight-V100"
    ".TemporaryItems"
    ".Trashes"
    ".VolumeIcon.icns"
    ".com.apple.timemachine.donotpresent"
    ".AppleDB"
    ".AppleDesktop"
    "Network Trash Folder"
    "Temporary Items"
    ".apdisk"
    "*~"
    ".fuse_hidden*"
    ".directory"
    ".Trash-*"
    ".nfs*"
  ]
  ++ extraIgnores;
  excludesfile = pkgs.writeText "gitignore-global" (pkgs.lib.concatLines ignores);
in
(pkgs.formats.gitIni { }).generate "gitconfig" {
  user = {
    inherit name email signingkey;
  };
  advice.defaultBranchName = false;
  gpg.format = "ssh";
  pull.rebase = true;
  merge.conflictstyle = "zdiff3";

  core = {
    inherit editor excludesfile;
    pager = "delta";
  };

  delta = {
    side-by-side = true;
    line-numbers = true;
    navigate = true;
    zero-style = "dim syntax";
    hyperlinks = true;
    true-color = "always";
  };

  diff = {
    algorithm = "histogram";
    colorMoved = "default";
  };

  interactive.diffFilter = "delta --color-only";

  init.defaultBranch = "main";
  fetch.prune = true;
  push = {
    autoSetupRemote = true;
    followTags = true;
  };
  rebase = {
    autoSquash = true;
    updateRefs = true;
  };
  rerere.enabled = true;
  commit = {
    verbose = true;
    gpgSign = sign;
  };
  branch.sort = "-committerdate";
  tag.sort = "version:refname";
  column.ui = "auto";
  help.autocorrect = "prompt";
  http.postBuffer = 157286400;
}
