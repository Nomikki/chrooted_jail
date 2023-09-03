#!/bin/sh
# add users
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

NEW_USER="$1"
D=$(cat vars.txt)

if grep -qE "^Match User" /etc/ssh/sshd_config; then
    if grep -qE "^Match User.*\<$NEW_USER\>" /etc/ssh/sshd_config; then
        echo "User '$NEW_USER' is already in list"
        exit 1
    fi
fi

if ! grep -qE "^Match User" /etc/ssh/sshd_config; then
    # create match user -list with new user
    adduser --gecos $NEW_USER

    echo "Match User $NEW_USER" | sudo tee -a /etc/ssh/sshd_config
    echo "ChrootDirectory $D" | sudo tee -a /etc/ssh/sshd_config

else 
    sudo sed -i "/^Match User/s/$/,$NEW_USER/" /etc/ssh/sshd_config
    adduser --gecos GECOS $NEW_USER
fi

mkdir -p $D/etc/
cp -f /etc/passwd $D/etc/
cp -f /etc/group $D/etc/

#create new home dir
mkdir -p $D/home/$NEW_USER
chown -R $NEW_USER:$NEW_USER $D/home/$NEW_USER
chown -R 0700 $D/home/$NEW_USER
chown $NEW_USER $D/home/$NEW_USER

systemctl restart ssh.service