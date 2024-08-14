# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


export PATH=~/scripts:$PATH
source log.sh

#Add aliases here
alias dcls='docker container ls'
alias dcr='docker compose restart'
alias df5='echo "y" | docker image prune; echo "y" | docker volume prune; echo "y" | docker network prune;'
alias dr-reset='docker compose down; docker compose build; docker compose up -d'
alias enva='source venv/bin/activate'
alias envd='deactivate'
alias f5='cd ..;cd -'
alias fdr="export FLASK_DEBUG=0"
alias fr5="export FLASK_DEBUG=1; flask run --host 0.0.0.0"
alias gs='git status'
alias gaa='git add --all'
alias gf5="git fetch --prune; git pull; git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D;"
alias gtree='git log --graph --decorate --pretty=oneline'
alias k=kubectl
alias kctx=kubectx
alias ll='ls -alth'
alias pip=pip3
alias python=python3
alias sad="sudo apt update"
alias sag="sudo apt upgrade"
alias tf=terraform
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias vncres='vncserver -kill :* | vncserver -geometry 1880x940'

#Add environment variables here.
export FLASK_APP=main.py
export PYTHONUNBUFFERED=1

clean-history | adddate "clean-history" >> $log
echo "Startup script started!" | adddate $0 >> $log
