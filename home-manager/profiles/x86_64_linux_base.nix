{
  config,
  pkgs,
  ...
}:

let
  overlays = import ./overlays.nix;
in

{

  imports = [ ./common.nix ];
  nixpkgs.overlays = [ overlays ];

  home = {
    username = "john";
    homeDirectory = "/home/john";
    packages = with pkgs; [
      bitwarden-cli
      fast-cli
      gnumake
      libvirt
      lyx
      pciutils
      podman
      podman-tui
      unzip
      zip
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      hms = "nix run $HOME/projects/dotfiles#homeConfigurations.nixos.activationPackage --show-trace";
      rdeps = "${pkgs.nix-tree}/bin/nix-tree \$HOME/projects/dotfiles#homeConfigurations.nixos.activationPackage --derivation";
      pbcopy = "${pkgs.xclip}/bin/xclip -sel clip";  # mimics macos
    };
  };

  programs.vim.plugins = with pkgs.vimPlugins; [
    vim-go  # broken on MacOS currently
  ];

  programs.git = {
    enable = true;
    userName = "John Whitman";
    userEmail = "john@s2sq.com";
  };

}

