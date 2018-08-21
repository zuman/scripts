#Usage: source log.sh
log="/home/szhusain/scripts/scripts.log"
adddate(){
    while IFS= read -r line; do
        echo "$(date) - $1 :: $line"
    done
}