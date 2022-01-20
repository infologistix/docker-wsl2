#!/bin/bash

PATH=$PATH:/mnt/c/Windows/system32:/mnt/c/windows/system32/WindowsPowershell/v1.0/

debian(){
    # this installs even the service for us...
    sudo apt install -y ca-certificates gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
}

ubuntu(){
    # this installs even the service for us...
    sudo apt install -y ca-certificates gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
}

install_docker(){
    ## debian based
    if [[ ! $(command -v apt) = "" ]]; then
    echo -e "This is Debian-based\nInstalling with apt..."
    sudo apt update
    sudo apt install -y ca-certificates gnupg lsb-release
    source /etc/os-release
    curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
    echo "deb [arch=amd64] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    fi
    if [[ ! $(command -v zypper) = "" ]]; then
    echo -e "This is OpenSUSE\nInstalling with zypper..."
    # openSUSE does not ship any service. Doing this by ourselves.
    sudo zypper in -y docker
    sudo curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/files/docker -o /etc/init.d/docker
    fi
}

install(){
echo -e "Installing docker with OS-setup"
install_docker
echo -e "Creating docker config..."
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json<<EOF
{
    "log-driver": "json-file",
    "log-level": "warn",
    "log-opts": {
        "max-size": "10m",
        "max-file": "5"
    },
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
echo "alias wsl_restart='/mnt/c/windows/system32/wsl.exe --shutdown $WSL_DISTRO_NAME'">$HOME/bin/docker-service
# configuring Service Startup
# Might be moved from docker-service to another bake :)
sudo tee /etc/profile.d/zzz-zzz-docker.sh<<EOF
sudo service docker start
source $HOME/bin/docker-service
EOF
sudo tee -a /etc/sudoers<<EOF
%docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd
%users ALL=(ALL) NOPASSWD: /usr/sbin/service docker *
EOF
sudo usermod -aG docker $USER
}

config_windows(){
mkdir -p /mnt/c/Docker
echo -e "\n------------------------------------------------"
echo -e "Downloading Docker Client for Windows to C:\Docker"
echo -e "-------------------------------------------------"
curl -fSL https://github.com/StefanScherer/docker-cli-builder/releases/download/20.10.9/docker.exe -o /mnt/c/Docker/docker.exe
echo -e "\nPlease add 'C:\Docker' to PATH Variable..."
echo -e "------------IMPORTANT---------------------"
echo -e "Press Windows-Key -> Type 'systemvar' and press enter."
echo -e "Continue clicking to 'Edit Variables | Variablen bearbeiten'"
echo -e "Add 'C:\Docker to PATH Variable and save."
echo -e "---------------END------------------------"
}

# Windows Preliminaries are currently missing
install
config_windows

echo -e "Docker is now available: Try: 'docker ps'"
read -p "Hit any Key to continue..." $KEY
wsl.exe --shutdown $WSL_DISTRO_NAME
