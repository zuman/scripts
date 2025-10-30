# Use the base image of Ubuntu 22.04
FROM ubuntu:24.04

# Update and upgrade the image
RUN apt update && apt upgrade -y

# Install required packages
RUN apt install -y build-essential
RUN apt install -y python3 python3-virtualenv ca-certificates
RUN pip install --upgrade pip
RUN apt install -y sudo git curl gnupg

# Create a non-root user with root privileges
ARG username
ARG password
RUN useradd -m -s /bin/bash -G sudo $username

# Set the password for the non-root user
RUN echo "$username:$password" | chpasswd

# Map the home directory of the user to an external directory
RUN mkdir -p /home/$username
RUN chown -R $username:$username /home/$username
ENV HOME=/home/$username

# Set the user as the default user for subsequent commands
USER $username

# Set the working directory to the user's home directory
WORKDIR $HOME

# Add your further instructions or dependencies here

# Run the command to keep the container running in the background
CMD tail -f /dev/null
