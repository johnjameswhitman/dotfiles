{
  config,
  pkgs,
  lib,
  ...
}:

{

  imports = [ ../profiles/common.nix ];

  programs.home-manager.enable = true;

  home = {
    username = "bits";
    homeDirectory = "/home/bits";
    packages = with pkgs; [
      mosh
    ];
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
      hms = "nix run \${HOME}/projects/dotfiles#homeConfigurations.workspace.activationPackage";
      rdeps = "${pkgs.nix-tree}/bin/nix-tree \${HOME}/projects/dotfiles#homeConfigurations.workspace.activationPackage --derivation";
    };
    envExtra = ''
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
      export BEADS_DIR="$HOME/dd/beads/.beads"
    '';
    initContent = ''
     fpath=(~/.zsh/completion $fpath)
     export PATH=$HOME/.local/bin:$PATH:/usr/local/bin
     source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

     # NVM stuff
     export NVM_DIR="$HOME/.nvm"
     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

     # Work stuff
     if [[ -f "''${HOME}/.zshrc_work" ]]; then
       . "''${HOME}/.zshrc_work"
     fi
   '';
  };

}
