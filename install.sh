#!/usr/bin/env bash
set -euo pipefail

echo "==> user: $(whoami), cwd: $(pwd)"

echo "==> Installing Nix..."
if ! command -v nix &>/dev/null; then
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-shell '<home-manager>' -A install
  "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
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
