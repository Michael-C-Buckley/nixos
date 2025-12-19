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
      pager = delta

    [interactive]
      diffFilter = delta --color-only

    [delta]
      side-by-side = true
      line-numbers = true
      navigate = true

    [merge]
      conflictStyle = zdiff3

    [http]
      postBuffer = 157286400

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
