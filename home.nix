{ config, pkgs, lazyvim, ... }:

{
  imports = [ lazyvim.homeManagerModules.default ];

  home = {
    username = "div";
    homeDirectory = "/home/div";
    stateVersion = "26.05";
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    fzf.enable = true;
    gcc.enable = true;
    gpg.enable = true;
    man.enable = true;
    onedrive.enable = true;
    ripgrep.enable = true;
    yazi.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    fish = {
      enable = true;

      interactiveShellInit = ''
        fish_add_path /nix/var/nix/profiles/default/bin ~/.nix-profile/bin
        fish_add_path ~/.local/bin

        set hydro_symbol_git_dirty " [dirty]"
        set hydro_symbol_git_ahead " [ahead]"
        set hydro_symbol_git_behind " [behind]"
      '';

      functions.fish_greeting = {
        body = ''
          set_color cyan
          echo "👋 Welcome back."
          echo (TZ=America/Indiana/Indianapolis date '+%H:%M | %a, %b %d %Y')
          set_color normal
        '';
      };

      shellAliases = {
        ls  = "eza --icons --group-directories-first";
        l   = "eza --icons --group-directories-first";
        la  = "eza -a --icons --group-directories-first";
        ll  = "eza -la --icons --group-directories-first";
        lt  = "eza --tree --icons --group-directories-first";
        lta = "eza --tree -a --icons --group-directories-first";

        g    = "git";
        gs   = "git status";
        gl   = "git log --oneline --graph --decorate --all";
        gp   = "git push";
        gpf  = "git push --force-with-lease";
        gpl  = "git pull";
        gf   = "git fetch";
        gr   = "git restore";
        grs  = "git restore --staged";
        gcl  = "git clone";

        ta  = "tmux attach";
        tls = "tmux ls";
        tn  = "tmux new -s";
        tk  = "tmux kill-session -t";

        tarnow = "tar acf";
        untar  = "tar xvf";

        ports = "ss -tulpen";
        myip  = "curl 4.ident.me";

        md = "mkdir -p";
        c  = "clear";
        chez = "chezmoi";
        h  = "history";
      };

      plugins = with pkgs.fishPlugins; [
        { name = "autopair"; src = autopair.src; }
        { name = "colored-man-pages"; src = colored-man-pages.src; }
        { name = "hydro"; src = hydro.src; }
        { name = "sponge"; src = sponge.src; }
      ];
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    git = {
      enable = true;
      lfs.enable = true;

      settings = {
        user = {
          name = "Divya Rasania";
          email = "70239770+DivyaRasania@users.noreply.github.com";
        };

        init.defaultBranch = "main";
      };
    };

    mise = {
      enable = true;
      enableFishIntegration = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    lazyvim = {
      enable = true;
      extras = {
        lang.nix.enable = true;
      };
      extraPackages = with pkgs; [
        lua-language-server
        stylua
      ];
    };

    tmux = {
      enable = true;
      mouse = true;
      newSession = true;
      shell = "${pkgs.fish}/bin/fish";
      plugins = with pkgs.tmuxPlugins; [
        resurrect
      ];
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;

      options = [
        "--cmd cd"
      ];
    };
  };
  
  home.packages = with pkgs; [
    duf
    dust
    entr
    fd
    procs
    tldr
    unzip

    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  
  programs.home-manager.enable = true;
}
