-- Let dwindle size Kitty instead of restoring a maximized OS window.
hl.window_rule({
  name = "kitty-tiled",
  match = { class = "(?i)^kitty$" },
  tile = true,
  fullscreen_state = "0 0",
  suppress_event = "maximize fullscreen",
})

-- Helium's Bitwarden extension popup uses a dedicated app class.
hl.window_rule({
  name = "bitwarden-extension-floating",
  match = { class = "^chrome-nngceckbapebfimnlniiiahkandclblb-Default$" },
  float = true,
})

-- Workspace matching follows windows as they move between workspaces.
hl.window_rule({
  name = "workspace-10-private",
  match = { workspace = "10" },
  no_screen_share = true,
})

hl.window_rule({
  name = "helium-workspace-1-private",
  match = { class = "(?i)^helium$", workspace = "1" },
  no_screen_share = true,
})

-- The dedicated incognito launcher uses its own process and window class.
-- Keep it private on every workspace, regardless of the active tab title.
hl.window_rule({
  name = "helium-incognito-private",
  match = { class = "^helium-incognito$" },
  no_screen_share = true,
})

-- Cover native Wayland app IDs and XWayland application classes.
-- Redact private application windows and their popups in screen captures.
hl.window_rule({
  name = "private-apps-no-screen-share",
  match = {
    class = "(?i)^(signal|signal-desktop|org[.]signal[.]Signal|telegram-desktop|TelegramDesktop|org[.]telegram[.]desktop)$",
  },
  no_screen_share = true,
})
