#!/bin/bash


# preliminaries

PATH=$PATH:/mnt/c/Windows/system32:/mnt/c/windows/system32/WindowsPowershell/v1.0/

install_docker(){
    ## debian based
    if [[ $(command -v apt) = ""]]; then
    echo -e "This is Debian-based\nInstalling with apt..."
    sudo apt install -y docker
    fi
    if [[ $(command -v zypper) = ""]]; then
    echo -e "This is OpenSUSE\nInstalling with zypper..."
    sudo zypper in -y docker
    fi
    if [[ $(command -v pacman) = ""]]; then
    echo -e "This is Arch\nInstalling with pacman..."
    sudo pacman -S --noconfirm docker
    fi
}

install(){
echo -e "Installing docker with OS-setup"
install_docker
echo -e "Creating docker config..."
sudo tee /etc/docker/daemon.json<<EOF
{
    "log-driver": "json-file",
    "log-level": "warn",
    "log-opts": {
        "max-size": "10m",
        "max-file": "5"
    },
    "group": "users",
    "experimental": false,
    "host": [
        "unix:///mnt/wsl/shared-docker/docker.sock"
    ]
}
EOF
mkdir -p $HOME/.docker
cat > $HOME/.docker/config.json<<EOF
{}
EOF
echo -e "Configuring Services and Startup"
mkdir -p $HOME/bin
curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/files/docker-service -o $HOME/bin/docker-service
# configuring Service Startup
# Might be moved from docker-service to another bake :)
sudo tee /etc/profile.d/zzz-zzz-dockerd.sh<<EOF
source $HOME/bin/docker-service
EOF
sudo tee -a /etc/sudoers<<EOF
Defaults env_keep=DOCKER_HOST
%users ALL=(ALL) NOPASSWD: ALL
%docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd /etc/init.d/dockerd
EOF
sudo usermod -aG docker $USER
}


# Windows Preliminaries are currently missing
install

echo -e "After installing. This is doing a clean restart...\nPlease oopen an new window!"
wsl.exe --shutdown -d $WSL_DISTRO_NAME
