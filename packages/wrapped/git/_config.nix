{extraConfig}:
''
  [advice]
      defaultBranchName = false

  [color]
    diff = "auto"
    interactive = "auto"
    status = "auto"
    ui = true

  [commit]
    gpgsign = true

  [gpg]
    format = ssh

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
    signingkey = "/home/michael/.ssh/id_ed25519_sk_rk_signing.pub"
''
+ extraConfig
