#!/bin/bash

# Define the container names
containers=("nextcloud-aio-apache" "nextcloud-aio-mastercontainer")

# Define the network name
network_name="common-proxy_default"

# Define the maximum number of retries
max_retries=20

# Sleep time
sleep_time=5

# Initialize counters
retries=0

# Function to check if Docker is running and wait for the containers with retries
check_docker_and_wait() {
    while [ $retries -lt $max_retries ]; do
        ((retries++))

        if docker info &>/dev/null; then
            # Docker is running
            all_connected=true

            for container_name in "${containers[@]}"; do
                container_id=$(docker ps -qf "name=$container_name")

                if [ -n "$container_id" ]; then
                    # Container is running
                    if docker network inspect "$network_name" | grep -q "$container_id"; then
                        # Container is already attached to the network
                        # echo "$retries. Container $container_name is already attached to $network_name."
                        continue
                    else
                        # Container is not attached to the network, attach it
                        if docker network connect "$network_name" "$container_id" &>/dev/null; then
                            echo "$retries. Container $container_name has been attached to $network_name."
                        else
                            echo "$retries. Failed to attach container $container_name to $network_name. Retrying..."
                            all_connected=false
                        fi
                    fi
                else
                    echo "$retries. Container $container_name is not running. Waiting for it to start..."
                    all_connected=false
                fi
            done

            if $all_connected; then
                return 0 # Success
            fi
        else
            echo "$retries. Docker is not running. Waiting for Docker to start..."
        fi

        # Sleep for a few seconds and increment the retry counter
        sleep $sleep_time
    done

    echo "Docker or containers did not start within the specified time."
    return 1 # Failure
}

# Check Docker availability and wait for the containers with retries
if ! check_docker_and_wait; then
    exit 1 # Script failed
fi

# Both Docker and containers are ready
exit 0 # Script succeeded
