#!/bin/bash

remove_install(){
    ## debian based
    if [[ $(command -v apt) = ""]]; then
    echo -e "This is Debian-based\nRemoving with apt..."
    sudo apt autoremove -y docker
    fi
    # suse based
    if [[ $(command -v zypper) = ""]]; then
    echo -e "This is OpenSUSE\nRemoving with zypper..."
    sudo zypper remove -y docker
    fi
    # arch based
    if [[ $(command -v pacman) = ""]]; then
    echo -e "This is Arch\nRemoving with pacman..."
    sudo pacman -R --noconfirm docker
    fi
}

remove_files(){
sudo rm /etc/docker/daemon.json
sudo rm /etc/init.d/dockerd
sudo rm /etc/profile.d/zzz-zzz-dockerd.sh
rm $HOME/bin/docker-service
sudo sed -i '%docker ALL=(ALL) NOPASSWD: \/usr\/bin\/dockerd/d' /etc/sudoers
sudo sed -i '%users ALL=(ALL) NOPASSWD: \/usr\/sbin\/service dockerd*/d' /etc/sudoers
}


sudo service docker stop
remove_install
remove_files

echo -e "After Removing. This is doing a clean restart...\nPlease oopen an new window!"
wsl.exe --shutdown -d $WSL_DISTRO_NAME