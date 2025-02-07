# My Personal Stuff
source $HOME/.bash_aliases # Also loads some env vars.
alias hf='cat ~/.zsh_history | grep -i '
alias api_shell='docker-compose exec api_flask /bin/bash'
alias api_logs='docker-compose logs -f --tail 100 api_flask'
PROMPT='%F{blue}%~%f %# '

# # Galileo Setup
# # Hook into `cd` so that I always activate the development env when
# # entering the API source tree.
# chpwd()
#   case $PWD in
#     (~/projects/api.galileo.io) source ~/projects/api.galileo.io/env/bin/activate
# esac

# https://github.com/galileo-inc/dotfiles
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# git -C ~/projects/dotfiles reset --hard origin/master > /dev/null 2>&1
# git -C ~/projects/dotfiles pull > /dev/null 2>&1
source $HOME/projects/dotfiles/bootstrap.sh

# https://docs.docker.com/compose/completion/#zsh 
fpath=(~/.zsh/completion $fpath)

# [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# added by Nix installer
if [ -e /Users/johnwhitman/.nix-profile/etc/profile.d/nix.sh ];
  then . /Users/johnwhitman/.nix-profile/etc/profile.d/nix.sh;
fi

