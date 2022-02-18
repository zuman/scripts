cp -r ../scripts ~
cp .profile ~
sed -i 's/PS1=.*/PS1="${debian_chroot:+($debian_chroot)}\\[\\033[01;34m\\][\\w]\\n\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\e[33m\\]\\d \\T\\[\\033[00m\\] \\$ "/g' $HOME/.bashrc
cd ~/scripts
chmod 755 clean-history
