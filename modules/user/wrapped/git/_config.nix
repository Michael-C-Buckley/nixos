{
  pkgs,
  extraConfig,
  gpgProgram,
  signingKey,
}:
pkgs.writeText "git-wrapped-config" (''
    [advice]
        defaultBranchName = false

    [color]
      diff = "auto"
      interactive = "auto"
      status = "auto"
      ui = true

    [commit]
      gpgsign = true
  ''
  + (
    if gpgProgram != null
    then ''
      program = "${gpgProgram}
    ''
    else ''''
  )
  + ''

    [core]
      editor = "nvim"

    [diff]
      external = "${pkgs.difftastic}/bin/difft"
      tool = "difftastic"

    [difftool "difftastic"]
      cmd = "${pkgs.difftastic}/bin/difft $LOCAL $REMOTE"

    [http]
      postBuffer = 157286400

    [merge]
      conflictstyle = "zdiff3"

    [user]
      email = "michaelcbuckley@proton.me"
      name = "Michael Buckley"
  ''
  + (
    if signingKey != null
    then ''
      signingkey = "${signingKey}"
    ''
    else ''''
  )
  + extraConfig)
