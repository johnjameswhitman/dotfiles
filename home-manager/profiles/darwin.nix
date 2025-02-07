{
  config,
  pkgs,
  lib,
  ...
}:

{

  imports = [ ./common.nix ];

  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      asdf-vm
      awscli2
      awslogs
      colima
      docker
      docker-compose
      qemu
      gnused
      kubecolor
      kubectl
      kubie
      poetry
      python3Packages.pipx
      ruby_3_2
      stow
      zsh-powerlevel10k
      # superTuxKart
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      k = "${pkgs.kubecolor}/bin/kubecolor";
      kctx = "${pkgs.kubie}/bin/kubie ctx";
      kns = "${pkgs.kubie}/bin/kubie ns";
    };
  };

}

