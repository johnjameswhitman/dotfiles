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
      libpg_query
      poetry
      postgresql
      python3Packages.pipx
      python3Packages.pglast
      python3Packages.psycopg2-binary
      ruby_3_2
      stow
      xcodes
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

