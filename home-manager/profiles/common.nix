{
  config,
  lib,
  pkgs,
  ...
}:

{

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  home.sessionPath = [
    "/home/john/.local/bin"
  ];

  home.file = {
    gitignore = {
      source = ../profiles/.gitignore;
      target = ".gitignore";
    };
    # ssh_config = {
    #   source = ../../.ssh/config;
    #   target = ".ssh/config";
    # };
  };

  home.packages = with pkgs; [
    cheat
    # claude-code
    cloc
    espeak
    exercism
    fzf
    gh
    gnupg
    go
    gopls
    gore
    go-task
    hyperfine
    inkscape
    jq
    kotlin
    kubectl
    maven
    mkcert
    mupdf
    nix-index
    nix-tree
    nodePackages.eslint
    packer
    pandoc
    pdftk
    python3
    python3Packages.pip
    python3Packages.black
    python3Packages.isort
    ripgrep
    rustup
    termdown
    tree
    uv
    # Virtualization
    # libvirt  # broken on MacOS/darwin right now (spidermonkey issue).
    # vagrant
    wget
    # Trial
    todoman
    vdirsyncer
    zulu  # java / jdk
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.k9s.enable = true;

  programs.git = {
    enable = true;
    settings = {
      core.excludesfile = "~/.gitignore";
      pull.rebase = false;
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.fish = {
    shellAliases = {
      ".." = "cd ..";
      ll = "ls -ahl";
      gobash = "env KEEP_BASH=true bash";
      gpsu = "git push origin --set-upstream $(git branch --show-current)";
      t = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py";
      td = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py done";
      te = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py edit";
      tet = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py edit --priority high --due today";
      tl = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due";
      tli = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Inbox";
      tlc = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Chores";
      tle = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Errands";
      tlr = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Reading";
      tlw = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Writing";
      tm = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move";
      tmr = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Reading";
      tmw = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Writing";
      tmc = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Chores";
      tme = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Errands";
      tn = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py new";
      tnt = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py new --priority high --due today";
      trepl = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py repl";
      ts = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py show";
      vs = "${pkgs.vdirsyncer}/bin/vdirsyncer --config=${config.xdg.configHome}/vdirsyncer/config sync";
      nds = "nix run nix-darwin -- switch --flake \$HOME/projects/kipos";
      k = "${pkgs.kubecolor}/bin/kubecolor";
      kctx = "${pkgs.kubie}/bin/kubie ctx";
      kns = "${pkgs.kubie}/bin/kubie ns";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    # Set up powerlevel10k theme
    # https://discourse.nixos.org/t/using-an-external-oh-my-zsh-theme-with-zsh-in-nix/6142/2?u=johnjameswhitman
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "kubectl" "terraform" "direnv" "aws"];
    };
    shellAliases = {
      gpsu = "git push origin --set-upstream $(git branch --show-current)";
      grep = "${pkgs.gnugrep}/bin/grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.direnv}";
      idea = "open -na 'IntelliJ IDEA.app'";
      hf = "cat ~/.zsh_history | grep -i ";
      # k = "${pkgs.kubectl}/bin/kubectl";
      k = "${pkgs.kubecolor}/bin/kubecolor";
      kctx = "${pkgs.kubie}/bin/kubie ctx";
      kns = "${pkgs.kubie}/bin/kubie ns";
      nds = "nix run nix-darwin -- switch --flake \${HOME}/projects/kipos";
      t = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py";
      td = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py done";
      te = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py edit";
      tet = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py edit --priority high --due today";
      tl = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due";
      tlc = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Chores";
      tle = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Errands";
      tli = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Inbox";
      tlr = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Reading";
      tlw = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py list --sort priority,due Writing";
      tm = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move";
      tmc = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Chores";
      tme = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Errands";
      tmi = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Inbox";
      tmr = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Reading";
      tmw = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py move --list Writing";
      tn = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py new";
      tnt = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py new --priority high --due today";
      trepl = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py repl";
      ts = "${pkgs.todoman}/bin/todo --config=${config.xdg.configHome}/todoman/config.py show";
      vs = "${pkgs.vdirsyncer}/bin/vdirsyncer --config=${config.xdg.configHome}/vdirsyncer/config sync --force-delete";
    };
  };

  programs.tmux = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.darcula-theme
      # epkgs.org
      # epkgs.org-ac
      # epkgs.org-download
      # epkgs.org-journal
      epkgs.markdown-mode
      epkgs.nix-mode
      epkgs.python-mode
      epkgs.use-package
    ];
  };

  programs.vim = {
    enable = true;

    settings = {
      expandtab = true;
      number = true;
      shiftwidth = 4;
      tabstop = 4;
    };

    extraConfig = ''
      " General settings
      set ruler
      filetype plugin indent on
      syntax enable
      set nofoldenable

      " Nav Split Panes
      " https://www.quora.com/How-do-I-switch-between-panes-in-split-mode-in-Vim
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l

      " Quick list buffers
      " https://stackoverflow.com/questions/16082991/vim-switching-between-files-rapidly-using-vanilla-vim-no-plugins
      nnoremap gb :ls<CR>:b<Space>

      " Highlight columns after 80
      if exists('+colorcolumn')
        set colorcolumn=80
        autocmd FileType java setlocal colorcolumn=100
      else
        au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
        autocmd FileType java au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
      endif

      " Toggle paste-mode with F2 key.
      nnoremap <F2> :set invpaste paste?<CR>
      set pastetoggle=<F2>
      set showmode

      " Change Working Directory to current file.
      " http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
      autocmd BufEnter * silent! lcd %:p:h

      " Wrap Markdown at 80ch
      au BufRead,BufNewFile *.md setlocal textwidth=80

      " Deal with trailing whitespace
      let g:better_whitespace_enabled=1
      let g:strip_whitespace_on_save=1

      " Enable gopls support
      let g:go_def_mode='gopls'
      let g:go_info_mode='gopls'
      let g:go_gopls_enabled = 1
      set completeopt=menuone,noinsert,noselect
    '';

    plugins = with pkgs.vimPlugins; [
      kotlin-vim
      python-mode
      typescript-vim
      vim-addon-nix
      vim-bazel
      vim-better-whitespace
      vim-fish
      vim-go
      vim-javascript
      vim-markdown
      vim-ruby
      vim-terraform
    ];

  };

  xdg.configFile."ideavim/ideavimrc".text = ''
    ${config.programs.vim.extraConfig}
  '';

  xdg.configFile."fish/completions/todo.fish".text = ''
    # _TODO_COMPLETE=fish_source todo > completions/.config/fish/completions/todo.fish
    function _todo_completion
        set -l response (env _TODO_COMPLETE=fish_complete COMP_WORDS=(commandline -cp) COMP_CWORD=(commandline -t) todo)

        for completion in $response
            set -l metadata (string split "," $completion)

            if test $metadata[1] = "dir"
                __fish_complete_directories $metadata[2]
            else if test $metadata[1] = "file"
                __fish_complete_path $metadata[2]
            else if test $metadata[1] = "plain"
                echo $metadata[2]
            end
        end
    end

    complete --no-files --command todo --arguments "(_todo_completion)"
  '';

  xdg.configFile."fish/completions/aws.fish".text = ''
    # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
    complete \
      --command aws \
      --no-files \
      --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
  '';

  xdg.configFile."yt-dlp/config".text = ''
    --format-sort "height:720"
    --cookies-from-browser firefox
  '';

}

