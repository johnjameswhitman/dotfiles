#!/usr/bin/env bash
set -euo pipefail

echo "==> user: $(whoami), cwd: $(pwd)"

echo "==> Installing Nix..."
if ! command -v nix &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  # Source nix in current shell
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "    Nix already installed, skipping."
fi

if [[ -f "${HOME}/.zshrc" && ! -L "${HOME}/.zshrc" ]]; then
  echo "==> Moving existing .zshrc to .zshrc_work..."
  mv "${HOME}/.zshrc" "${HOME}/.zshrc_work"
fi

echo "==> Activating workspace home-manager configuration..."
nix run "${HOME}/projects/dotfiles#homeConfigurations.workspace.activationPackage"

echo "==> Done! Restart your shell to pick up changes."
