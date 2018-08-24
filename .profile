export PATH=~/scripts:$PATH
force_color_prompt=yes
source log.sh
source ~/.prompt
#Add aliases here
clean-history | adddate "clean-history" >> $log
echo "Startup script started!" | adddate $0 >> $log
