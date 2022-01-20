#!/bin/bash


# preliminaries

PATH=$PATH:/mnt/c/Windows/system32:/mnt/c/windows/system32/WindowsPowershell/v1.0/

debian(){
    # this installs even the service for us...
    sudo apt install ca-certificates gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-client containerd.io
}

install_docker(){
    ## debian based
    if [[ ! $(command -v apt) = "" ]]; then
    echo -e "This is Debian-based\nInstalling with apt..."
    debian
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
# configuring Service Startup
# Might be moved from docker-service to another bake :)
sudo tee /etc/profile.d/zzz-zzz-dockerd.sh<<EOF
sudo service dockerd start
alias wsl_restart = "/mnt/c/Windows/system32/wsl.exe -d $WSL_DISTRO_NAME --shutdown"
EOF
sudo tee -a /etc/sudoers<<EOF
%docker ALL=(ALL) NOPASSWD: /usr/bin/dockerd
%users ALL=(ALL) NOPASSWD: /usr/sbin/service dockerd*
EOF
sudo usermod -aG docker $USER
newgrp docker
sudo service docker start
}

config_windows() {
    ## work to be done...
    mdkir -p /mnt/c/Docker
    curl -fsSL https://github.com/StefanScherer/docker-cli-builder/releases/download/20.10.9/docker.exe -o /mnt/c/Docker/docker.exe
    echo -e "Please add 'C:\Docker' to PATH Variable..."
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
