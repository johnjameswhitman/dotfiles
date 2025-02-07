. $HOME/.environment_variables

# Aliases
alias abcde='abcde -N $1'
alias tn='tmux new -s $1'
alias ta='tmux attach -t $1'
alias td='tmux detach'
alias tls='tmux ls'
alias tkt='tmux kill-session -t $1'
alias blaze='bazel'
alias g4d='cd "$(bazel info workspace)"'
alias to_c='cd /home/john/projects/coursera-roughgarden-algos/src/main/c/krcpl'
alias ll='ls -ahl'

# Hugo Web Server
alias hw='hugo server -wDEF --cleanDestinationDir --forceSyncStatic --gc'

# Nix
if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
  source ~/.nix-profile/etc/profile.d/nix.sh
fi

# pyenv things
# export PYENV_ROOT="/usr/local/opt/pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# Removed below while attempting to get nix home-manager working.
# export PATH="/home/john/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# SSH Agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

