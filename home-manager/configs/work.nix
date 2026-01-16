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
    settings = {
      user.name = "John Whitman";
      user.email = "john.whitman@datadoghq.com";
    };
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
      export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
      export BEADS_HOME="$HOME/dd/beads"
    '';
    initContent = ''
     fpath=(~/.zsh/completion $fpath)
     export PATH=$HOME/.local/bin:$PATH:/usr/local/bin
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

     # BEGIN SCFW MANAGED BLOCK
     alias npm="scfw run npm"
     alias pip="scfw run pip"
     alias poetry="scfw run poetry"
     export SCFW_DD_AGENT_LOG_PORT="10365"
     export SCFW_DD_LOG_LEVEL="ALLOW"
     export SCFW_HOME="/Users/john.whitman/.scfw"
     # END SCFW MANAGED BLOCK
   '';
  };

}

