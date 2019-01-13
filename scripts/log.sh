#Usage: source log.sh
#Replace szhusain with your username
log="/home/$USER/scripts/scripts.log"
adddate(){
    while IFS= read -r line; do
        echo "$(date) - $1 :: $line"
    done
}
