# Dotfiles

## Prerequisites

- Install stow

```bash
sudo pacman -S stow
```

## Install

Clone the repo:

```bash
git clone https://github.com/DanielSintimbrean/dotfiles.git ~/dotfiles/
```

## Configure stow

```bash
cd ~/dotfiles/ && stow * --adopt --dotfiles
```

```bash
git restore .
```

## Tmux

### Install TPM 

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

```bash
tmux-dev
```

`Ctrl + Space` + `I`: To install the plugins

## Install applications that i use

```bash
sudo pacman -s zoxide fnm docker nerd-fonts syncthing diff-so-fancy
```

### From aur

```bash
yay -S bun
```

### Install npm dependencies with bun

```bash
bun add -g npm-check-dependencies cz-git @antfu/ni commitizen
```

## Enable docker

```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo systemctl start docker.service
sudo systemctl start containerd.service
```

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

### Verify

```bash
docker run hello-world
```

### Install portainer

[Official Docs](https://docs.portainer.io/start/install-ce/server/docker/linux#deployment)

### Install neovim configuration

#### Install needed dependencies

```bash
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim xclip
```

## caps2esc 

[link](https://gitlab.com/interception/linux/plugins/caps2esc)

```bash
sudo pacman -S interception-tools interception-caps2esc
```

