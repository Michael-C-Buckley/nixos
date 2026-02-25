{
  flake.hjemConfigs.termfilechooser = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-termfilechooser
      yazi
    ];

    hjem.users.michael.xdg.config.files = {
      "xdg-desktop-portal/portals.conf".text = ''
        [preferred]
        default=gtk;
        org.freedesktop.impl.portal.FileChooser=termfilechooser
      '';

      "xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${config.hjem.users.michael.xdg.config.directory}/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME
      '';

      "xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
        executable = true;
        text =
          # bash
          ''
            #!/usr/bin/env bash
            # See man 5 xdg-desktop-portal-termfilechooser for argument documentation

            set -e

            if [ "$6" -ge 4 ]; then
                set -x
            fi

            multiple="$1"
            directory="$2"
            save="$3"
            path="$4"
            out="$5"

            cmd="yazi"
            termcmd="kitty"

            if [ "$save" = "1" ]; then
              set -- --chooser-file="$out" "$path"
            elif [ "$directory" = "1" ]; then
              set -- --chooser-file="$out" "$path"
            elif [ "$multiple" = "1" ]; then
              set -- --chooser-file="$out" "$path"
            else
              set -- --chooser-file="$out" "$path"
            fi

            command="$termcmd $cmd"
            for arg in "$@"; do
              escaped=$(printf "%s" "$arg" | sed 's/"/\\"/g')
              command="$command \"$escaped\""
            done

            sh -c "$command"
          '';
      };
    };
  };
}
