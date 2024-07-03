# Dotfiles

## Prerequisites

- Install stow


```bash
sudo pacman -S stow
```

## Install

Clone the repo:

```
git clone https://github.com/DanielSintimbrean/dotfiles.git ~/dotfiles/
```

## Configure stow

```bash
cd ~/dotfiles/ && stow . --adopt
```

```
git restore .
```

## Tmux


```
tmux-dev
```

`Ctrl + Space` + `I`: To install the plugins

## Install applications that i use

```
sudo pacman -s zoxide fnm docker nerd-fonts syncthing diff-so-fancy
```

### From aur

```
bun
```

### Install with bun

```
bun add -g npm-check-dependencies cz-git @antfu/ni commitizen
```

## Enable docker

```
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo systemctl start docker.service
sudo systemctl start containerd.service
```

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

### Verify

```
docker run hello-world
```

### Install portainer

https://docs.portainer.io/start/install-ce/server/docker/linux#deployment

