{
  config,
  pkgs,
  lib,
  ...
}:

{

  imports = [ ../profiles/darwin.nix ];

  programs.home-manager.enable = true;

  home = {
    username = "johnwhitman";
    homeDirectory = "/Users/johnwhitman";
  };

  programs.git = {
    enable = true;
    userName = "John Whitman";
    userEmail = "johnjameswhitman@gmail.com";
    # delta.enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      hms = "nix run \${HOME}/projects/dotfiles#homeConfigurations.personal.activationPackage";
      rdeps = "${pkgs.nix-tree}/bin/nix-tree \${HOME}/projects/dotfiles#homeConfigurations.personal.activationPackage --derivation";
    };
    initContent = ''
     eval "$(/opt/homebrew/bin/brew shellenv)"
     fpath=(~/.zsh/completion $fpath)
     export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
     source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
     source $HOME/.nix-profile/share/asdf-vm/asdf.sh
     source $HOME/.nix-profile/share/asdf-vm/completions/asdf.bash

     # NVM stuff
     export NVM_DIR="$HOME/.nvm"
     [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
   '';
  };

  services.syncthing.enable = true;

  xdg.configFile."vdirsyncer/config".text = ''
    # Ref: http://vdirsyncer.pimutils.org/

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
    date_format = "%Y-%m-%d"
    default_command = "list --sort priority,due"
    default_due = 0
    default_list = "Inbox"
    path = "${config.xdg.dataHome}/calendars/*"
    time_format = "%H:%M"
  '';

  launchd.enable = true;
  launchd.agents."vdirsyncer-runner" = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.vdirsyncer}/bin/vdirsyncer"
        "--config=${config.xdg.configHome}/vdirsyncer/config"
        "sync"
        "--force-delete"
      ];
      WatchPaths = [
        "${config.xdg.dataHome}/calendars"
      ];
      # StandardOutPath = "${config.home.homeDirectory}/Downloads/vdirsyncer-stdout.log";
      # StandardErrorPath = "${config.home.homeDirectory}/Downloads/vdirsyncer-stderr.log";
      ProcessType = "Background";
      StartInterval = 300;
      TimeOut = 30;
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

}

