{
  config,
  environment,
  pkgs,
  ...
}:

{

  imports = [ ./x86_64_linux_base.nix ];

  home = {
    username = "john";
    homeDirectory = "/home/john";
    packages = with pkgs; [
      anytype
      # blender  # Interferes with Python. Ref: https://github.com/NixOS/nixpkgs/blob/655a58a72a6601292512670343087c2d75d859c1/pkgs/applications/misc/blender/default.nix#L74
      devdocs-desktop
      doctl
      expect
      fio
      freetube
      ghostwriter
      gimp
      gnumeric
      google-chrome
      hunspell
      hunspellDicts.en_US-large
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.webstorm
      joplin-desktop
      # kdePackages.kamoso  # broken
      kdePackages.kdenlive
      kdePackages.kimageformats
      kdePackages.krdc
      kdePackages.merkuro
      languagetool
      libreoffice-qt
      meslo-lg
      mono4
      nixos-shell
      obsidian
      pidgin-with-plugins
      spotify
      xclip
      xdg-utils
      zeal
      # trialing things:
      # darktable
      bun
      go
      koreader
      # solaar  # logitech util
      wineWowPackages.stable
      winetricks
      vscode-fhs
      # playonlinux  # Not compatible with Python 3.12
      qbittorrent
      psst
      rbw
    ];
    sessionVariables = {
      DICPATH = "${pkgs.hunspellDicts.en_US-large}/share/hunspell";
    };
  };

  # services.kdeconnect.enable = true;
  services.syncthing.enable = true;

  programs.chromium.enable = true;

  # programs.firefox = {
  #   enable = true;
  #   # profiles = {
  #   #   everyday = {
  #   #     settings = {
  #   #       "general.smoothScroll" = false;
  #   #     };
  #   #   };
  #   # };
  # };

  systemd.user.startServices = true;  # auto-restarts services on switch.

  # systemd.user.sockets.podman = {
  #   Unit = {
  #     Description = "Podman API Socket";
  #     Documentation = "man:podman-system-service(1)";
  #   };

  #   Socket = {
  #     ListenStream = "%t/podman/podman.sock";
  #     SocketMode = "0660";
  #   };

  #   Install = {
  #     WantedBy = [ "sockets.target" ];
  #   };
  # };

  # systemd.user.services.podman = {
  #   Unit = {
  #     Description = "Podman API Service";
  #     Documentation = "man:podman-system-service(1)";
  #     Requires= [ "podman.socket" ];
  #     After= [ "podman.socket" ];
  #     StartLimitIntervalSec = 0;
  #   };

  #   Service = {
  #     ExecStart = [ "" "${pkgs.podman}/bin/podman $LOGGING system service" ];
  #     Type = "exec";
  #     KillMode = "process";
  #     Environment = ''
  #       LOGGING="--log-level=debug"
  #     '';
  #   };

  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  # };

  # Below service and timer poke watched directory to trigger sync.
  systemd.user.services.vdirsyncer-poker = {
    Unit = {
      Description = "Triggers sync of local and remote CalDav resources";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils-full}/bin/touch ${config.xdg.dataHome}/calendars/poke";
    };
  };

  systemd.user.timers.vdirsyncer-poker = {
    Unit = {
      Description = "Sync calendars every 1m";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
    };
  };

  # Below units should sync todos when todoman changes them.
  systemd.user.services.vdirsyncer-watcher = {
    Unit = {
      Description = "Synchronizes local and remote CalDav resources";
    };

    Service = {
      Restart = "always";
      RuntimeMaxSec = "60m";
      ExecStart = 
        let
          scriptName = "vdirsyncer-watcher.sh";
          out = pkgs.writeShellScriptBin scriptName ''
            set -e

            # Batch changes every 15s.
            next_allowed_sync=$(${pkgs.coreutils-full}/bin/date +%s)
            ${pkgs.inotify-tools}/bin/inotifywait \
              --monitor \
              --recursive \
              --event=create \
              --event=modify \
              --event=attrib \
              --event=delete \
              --event=move \
              --format='%T' \
              --timefmt='%s' \
              ${config.xdg.dataHome}/calendars | \
                while read event_time; do
                  if [[ $event_time -ge $next_allowed_sync ]]; then
                    next_allowed_sync=$(${pkgs.coreutils-full}/bin/date --date="15sec" +%s)
                    ${pkgs.coreutils-full}/bin/sleep 15
                    ${pkgs.vdirsyncer}/bin/vdirsyncer --config=${config.xdg.configHome}/vdirsyncer/config sync
                  fi
                done
          '';
        in "${out}/bin/${scriptName}";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.configFile."vdirsyncer/config".text = ''
    # Ref: http://vdirsyncer.pimutils.org/
    # To get set up:
    # vdirsyncer --config ~/.config/vdirsyncer/config discover cals
    # vdirsyncer --config ~/.config/vdirsyncer/config metasync
    # vdirsyncer --config ~/.config/vdirsyncer/config sync

    [general]
    # A folder where vdirsyncer can store some metadata about each pair.
    status_path = "${config.xdg.configHome}/vdirsyncer/status/"

    # CALDAV
    [pair cals]
    conflict_resolution = "b wins"
    a = "cal_local"
    b = "cal_s2sq"
    collections = ["from b"]

    # Calendars also have a color property
    metadata = ["displayname", "color"]

    [storage cal_local]
    type = "filesystem"
    path = "${config.xdg.dataHome}/calendars/"
    fileext = ".ics"

    [storage cal_s2sq]
    type = "caldav"
    url = "https://calendar.s2sq.com/jjw/"
    username = "jjw"
    password.fetch = ["command", "${pkgs.python3Packages.keyring}/bin/keyring", "get", "calendar.s2sq.com", "jjw"]
  '';

  xdg.configFile."todoman/config.py".text = ''
    # A glob expression which matches all directories relevant.
    path = "${config.xdg.dataHome}/calendars/*"
    date_format = "%Y-%m-%d"
    default_command = "list --sort priority,due"
    default_due = 0
    default_list = "Inbox"
    time_format = "%H:%M"
  '';

}

