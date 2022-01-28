# infologistix Docker WSL2 Installer

Docs:    
[German](#DE)    
[English](#EN)

## DE

Dieser Installer ermöglicht eine nahtlose Integration von Docker in ein Windows Environment. Einzige Voraussetzung ist eine installierte WSL-Distribution. Für diese Installation wird die Docker-Engine für Linux verwendet und die Docker-Desktop Version komplett aus dem System eliminiert.Eine ausführliche Anleitung ist hier zu finden: https://infologistix.de/docker-desktop-kostenfreie-alternative/

### Installation

Der Installer unterstützt zum gegenwärtigen Zeitpunkt folgende Distributionen:
- Debian
- Ubuntu
- OpenSUSE

Docker kann mit folgendem Befehl innerhalb der WSL installiert werden:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/install.sh)
```

### Usage

Unter Windows ist die Pfadvariable hinzuzufügen. Der Installer installier einen Docker Client nach `C:\Docker\docker.exe`. Dieser Pfad muss einmalig angegeben werden, dann ist Docker auch in Windows vorhanden.   
Die Benutzung erfolgt dann mit einem `docker context`:
```powershell
docker context create wsldocker --docker host=tcp://localhost:2375
docker context use wsldocker
```

### Deinstallation
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/uninstall.sh)
```

## EN

This installer enables a seamless integration of Docker into a Windows environment. The only requirement is an installed WSL distribution. For this installation, the Docker Engine for Linux is used and Docker Desktop is completely eliminated from the system. A detailed instruction can be found here: https://infologistix.de/en/docker-desktop-becomes-a-paid-subscription-service-discover-our-free-alternative/

### Installation

The installer supports only this 3 distros at the moment:
- Debian
- Ubuntu
- OpenSUSE

Install docker with
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/install.sh)
```

### Usage

On Windows, add docker to the PATH variable. The installer moves a Docker client to `C:\Docker\docker.exe`. This path must be specified only one time, then Docker is also usable with Windows Terminals.   
Usage from Windows is with `docker context`:
```powershell
docker context create wsldocker --docker host=tcp://localhost:2375
docker context use wsldocker
```

### Deinstallation
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/infologistix/docker-wsl2/main/uninstall.sh)
```

## Notes

### Credit

[pickmylight](https://github.com/pickmylight)    
[infologistix](https://infologistix.de)    
:octocat: [Github](https://github.com/infologistix)   
2022
