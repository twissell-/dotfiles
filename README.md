dotfiles
========

bash
----

* Powerline: [starship][starship]

i3
--

* Lockscreen: [i3lock-fancy-multimonitor][i3lock-fancy-multimonitor]
* App Menu: [rofi][rofi]

fish (old)
----------

 * Framework: [Oh My Fish][oh-my-fish]
 * Theme: [bobthefish][bobthefish]
 * Font: *Source Code Pro* [powerline/fonts][powerline-fonts]

TODO
----

[ ] Add i3lock + imagemagick installer
[ ] Add Fira Code installer
[ ] Add Nerd Fonts installer
[ ] Remove hostname from powerline config

[i3lock-fancy-multimonitor]: https://github.com/guimeira/i3lock-fancy-multimonitor
[oh-my-fish]: https://github.com/oh-my-fish/oh-my-fish
[bobthefish]: https://github.com/oh-my-fish/theme-bobthefish
[powerline-fonts]: https://github.com/powerline/fonts
[starship]: https://starship.rs
[rofi]: https://github.com/DaveDavenport/rofi

## Installation guide

### OS

- Install Ubuntu desktop
  - Standard/minimal installation.
  - Single partition
  - No swap

### Initial setup

```sh
sudo apt update && \
sudo apt full-upgrade -y && \
sudo apt autoremove --purge -y && \
sudo apt autoclean
```

```
sudo apt install git i3 rofi feh
sudo reboot
```

### Create s SSH key and add it to Github

```sh
ssh-keygen -t ed25519 -C "dmaggioesne@gmail.com"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

### Clone this repository

```sh
mkdir ~/bin && cd ~/bin
git clone git@github.com:twissell-/dotfiles.git
```

### VS Code

- Download and install the `.deb` from its website.
- Sign in and let it sync.

```sh
snap install shfmt
```

### i3 configuration

```sh
sudo apt update && sudo apt install scrot imagemagick -y
```

### Browser

- Download and install the `.deb` from its website.
- Download and install bitwarden extension.
- Login into vivaldi and sync.
