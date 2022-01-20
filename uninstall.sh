#!/bin/bash

remove_install(){
    ## debian based
    if [[ $(command -v apt) = ""]]; then
    echo -e "This is Debian-based\nRemoving with apt..."
    sudo apt autoremove -y docker-ce docker-ce-client containerd.io
    fi
    # suse based
    if [[ $(command -v zypper) = ""]]; then
    echo -e "This is OpenSUSE\nRemoving with zypper..."
    sudo zypper remove -y docker
    fi
}

remove_files(){
sudo rm /etc/docker/daemon.json
sudo rm /etc/init.d/docker
sudo rm /etc/profile.d/zzz-zzz-docker.sh
sudo sed -i '%docker ALL=(ALL) NOPASSWD: \/usr\/bin\/dockerd/d' /etc/sudoers
sudo sed -i '%users ALL=(ALL) NOPASSWD: \/usr\/sbin\/service dockerd*/d' /etc/sudoers
}


sudo service docker stop
remove_install
remove_files

echo -e "After Removing. This is doing a clean restart...\nPlease oopen an new window!"
wsl.exe --shutdown -d $WSL_DISTRO_NAME