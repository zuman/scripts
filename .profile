export PATH=~/scripts:$PATH
force_color_prompt=yes
source log.sh
source ~/.prompt

#Add aliases here
alias python=python3
alias pip=pip3
alias sag="sudo apt upgrade"
alias sad="sudo apt update"
alias vncres='vncserver -kill :* | vncserver -geometry 1880x940'
alias enva='source venv/bin/activate'
alias envd='deactivate'
alias sss="sudo supervisorctl status"
alias ssr="sudo supervisorctl restart"
alias gtree="git log --graph --decorate --pretty=oneline"
alias fr5="flask run --host 0.0.0.0"

#Add environment variables here.

clean-history | adddate "clean-history" >> $log
echo "Startup script started!" | adddate $0 >> $log
