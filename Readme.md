# infologistix Docker WSL2 Installer

## DE

Dieser Installer ermöglicht eine nahtlose Integration von Docker in ein Windows Environment. Einzige Voraussetzung ist eine installierte WSL-Distribution. Für diese Installation wird die Docker-Engine für Linux verwendet und die Docker-Desktop Version komplett aus dem System eliminiert.

### Installation

Der Installer unterstützt zum gegenwärtigen Zeitpunkt folgende Distributionen:
- Debian (Ubuntu, Debian, Kali)
- OpenSUSE (Leap, Tumbleweed)

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

TBD
