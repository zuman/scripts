# https://github.com/nextcloud/all-in-one/blob/main/reverse-proxy.md

docker run \
    --sig-proxy=false \
    --name nextcloud-aio-mastercontainer \
    --restart always \
    --publish 1080:8080 \
    --env APACHE_PORT=11000 \
    --env APACHE_IP_BINDING=0.0.0.0 \
    --volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    nextcloud/all-in-one:latest

SCRIPT_PATH="$HOME/scripts"

source $SCRIPT_PATH/log.sh

cp nextcloud-connect.sh $SCRIPT_PATH

(
    crontab -l
    echo "*/5 * * * * /bin/bash -c 'source $SCRIPT_PATH/log.sh; $SCRIPT_PATH/nextcloud-connect.sh | adddate nextcloud-connect >> $log 2>&1'"
) | crontab -

echo "Script $SCRIPT_PATH/nextcloud-connect.sh added to cron for startup."
