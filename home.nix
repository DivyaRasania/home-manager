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

        alias = {
          a = "add";
          aa = "add --all";
          ap = "add --patch";
          b = "branch";
          ba = "branch -a";
          bd = "branch -d";
          c = "commit";
          ca = "commit --amend";
          can = "commit --amend --no-edit";
          cm = "commit -m";
          co = "checkout";
          cb = "checkout -b";
          d = "diff";
          ds = "diff --staged";
          f = "fetch";
          l = "log --oneline --graph --decorate --all";
          last = "log -1 HEAD --stat";
          m = "merge";
          p = "push";
          pf = "push --force-with-lease";
          pl = "pull";
          r = "restore";
          rb = "rebase";
          rbi = "rebase -i";
          rs = "restore --staged";
          s = "status -sb";
          st = "stash";
          stp = "stash pop";
          sw = "switch";
          swc = "switch -c";
          undo = "reset --soft HEAD~1";
          unstage = "restore --staged";
          wip = "!git add -A && git commit -m 'wip'";
        };
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

  # static fish completions (built at switch time — prefer this over `| source` at shell start)
  xdg.configFile."fish/completions/gh.fish".source =
    pkgs.runCommand "gh-fish-completion" { nativeBuildInputs = [ pkgs.gh ]; } ''
      gh completion -s fish > $out
    '';

  xdg.configFile."fish/completions/tailscale.fish".source =
    pkgs.runCommand "tailscale-fish-completion" { nativeBuildInputs = [ pkgs.tailscale ]; } ''
      tailscale completion fish > $out
    '';
  
  home.packages = with pkgs; [
    duf
    dust
    entr
    fd
    procs
    tailscale
    tldr
    unzip

    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  
  programs.home-manager.enable = true;
}
