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
        "unix:///var/run/docker.sock",
        "tcp://localhost:2375"
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
curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/files/dockerd -o /etc/init.d/dockerd
# configuring Service Startup
# Might be moved from docker-service to another bake :)
sudo tee /etc/profile.d/zzz-zzz-dockerd.sh<<EOF
sudo service dockerd start
source $HOME/bin/docker-service
EOF
sudo tee -a /etc/sudoers<<EOF
%docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd
%users ALL=(ALL) NOPASSWD: /usr/sbin/service dockerd*
EOF
sudo usermod -aG docker $USER
sudo service docker start
}

config_windows() {
    ## work to be done...
    #curl -fsSL https://github.com/StefanScherer/docker-cli-builder/releases/download/20.10.9/docker.exe -o /mnt/c/Anwendungen
}

# Windows Preliminaries are currently missing
install

echo -e "Docker is now available: Try: 'docker ps'"