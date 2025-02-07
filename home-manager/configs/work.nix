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
    username = "john.whitman";
    homeDirectory = "/Users/john.whitman";
  };

  programs.git = {
    enable = true;
    userName = "John Whitman";
    userEmail = "john.whitman@datadoghq.com";
    # delta.enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      hms = "nix run \${HOME}/projects/dotfiles#homeConfigurations.work.activationPackage";
      rdeps = "${pkgs.nix-tree}/bin/nix-tree \${HOME}/projects/dotfiles#homeConfigurations.work.activationPackage --derivation";
    };
    envExtra = ''
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
    '';
    initExtra = ''
     fpath=(~/.zsh/completion $fpath)
     export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
     source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
     source $HOME/.nix-profile/share/asdf-vm/asdf.sh
     source $HOME/.nix-profile/share/asdf-vm/completions/asdf.bash

     # NVM stuff
     export NVM_DIR="$HOME/.nvm"
     [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm

     # Work stuff
     if [[ -f "''${HOME}/.zshrc_work" ]]; then
       . "''${HOME}/.zshrc_work"
     fi
   '';
  };

}

