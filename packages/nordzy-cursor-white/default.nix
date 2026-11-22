{ runCommand, nordzy-cursor-theme }:
runCommand "nordzy-cursor-white" { meta.description = "Nordzy Cursor - White"; } ''
  mkdir -p $out/share/icons
  cp -r ${nordzy-cursor-theme}/share/icons/Nordzy-cursors-white $out/share/icons/
  cp -r ${nordzy-cursor-theme}/share/icons/Nordzy-hyprcursors-white $out/share/icons/
''
