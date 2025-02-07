# dotfiles

Collection of my own configs and setup scripts. It turns out GNU `stow` is a
really useful file for auto-symlinking these. The way to use it is to group the
config fils for each program into their own _package_ folders where the
subfolders inside the package represent a target tree (e.g. `emacs/.emacs.d`).
Then, you symlink them to the desired location by doing:

```shell
stow --target ~ emacs
cd home-manager && stow --target ~ nixos
```

