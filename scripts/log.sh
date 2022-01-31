#Usage: source log.sh
log="$HOME/scripts/scripts.log"
touch $log
adddate(){
    while IFS= read -r line; do
        echo "$(date) - $1 :: $line"
    done
}
