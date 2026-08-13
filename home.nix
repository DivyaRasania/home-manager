{ config, pkgs, lazyvim, ... }:

{
  # ---------------------------------------------------------------------------
  # Home identity
  # stateVersion should only change when you intentionally migrate HM state.
  # ---------------------------------------------------------------------------
  home = {
    username = "div";
    homeDirectory = "/home/div";
    stateVersion = "26.05";
  };

  programs = {
    # -------------------------------------------------------------------------
    # Simple CLI tools (enable-only)
    # -------------------------------------------------------------------------
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

    # Better git diffs/pagers
    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    # -------------------------------------------------------------------------
    # Fish shell
    # Login shell is still set via chsh; this manages config, aliases, plugins.
    # -------------------------------------------------------------------------
    fish = {
      enable = true;

      interactiveShellInit = ''
        fish_add_path /nix/var/nix/profiles/default/bin ~/.nix-profile/bin
        fish_add_path ~/.local/bin
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
        # listing (eza)
        ls = "eza --icons --group-directories-first";
        l = "eza --icons --group-directories-first";
        la = "eza -a --icons --group-directories-first";
        ll = "eza -la --icons --group-directories-first";
        lt = "eza --tree --icons --group-directories-first";
        lta = "eza --tree -a --icons --group-directories-first";

        # tmux
        ta = "tmux attach";
        tls = "tmux ls";
        tn = "tmux new -s";
        tk = "tmux kill-session -t";

        # archives / network / misc
        tarnow = "tar acf";
        untar = "tar xvf";
        ports = "ss -tulpen";
        myip = "curl 4.ident.me";
        md = "mkdir -p";
        c = "clear";
        h = "history";
      };

      plugins = with pkgs.fishPlugins; [
        { name = "autopair"; src = autopair.src; }
        { name = "colored-man-pages"; src = colored-man-pages.src; }
        { name = "hydro"; src = hydro.src; } # prompt
        { name = "sponge"; src = sponge.src; } # drop failed commands from history
      ];
    };

    # -------------------------------------------------------------------------
    # GitHub CLI
    # config.yml is HM-managed (read-only). Auth tokens live in hosts.yml.
    # If `gh auth login` fails on config.yml, temporarily replace the symlink
    # with a writable file, log in, then re-run home-manager switch.
    # -------------------------------------------------------------------------
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        # Pre-set fields so auth doesn't need to mutate config.yml as often.
        version = 1;
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    # -------------------------------------------------------------------------
    # Git
    # Use as: git s / git cm "msg" / git undo  (see alias block)
    # -------------------------------------------------------------------------
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
          # staging
          a = "add";
          aa = "add --all";
          ap = "add --patch";
          unstage = "restore --staged";

          # commit
          c = "commit";
          ca = "commit --amend";
          can = "commit --amend --no-edit";
          cm = "commit -m";
          undo = "reset --soft HEAD~1";
          wip = "!git add -A && git commit -m 'wip'";

          # branches / navigation
          b = "branch";
          ba = "branch -a";
          bd = "branch -d";
          co = "checkout";
          cb = "checkout -b";
          sw = "switch";
          swc = "switch -c";

          # inspect
          s = "status -sb";
          d = "diff";
          ds = "diff --staged";
          l = "log --oneline --graph --decorate --all";
          last = "log -1 HEAD --stat";

          # sync / history rewrite
          f = "fetch";
          p = "push";
          pf = "push --force-with-lease";
          pl = "pull";
          m = "merge";
          r = "restore";
          rs = "restore --staged";
          rb = "rebase";
          rbi = "rebase -i";
          st = "stash";
          stp = "stash pop";
        };
      };
    };

    # -------------------------------------------------------------------------
    # Dev tooling / editors
    # -------------------------------------------------------------------------
    mise = {
      enable = true;
      enableFishIntegration = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # -------------------------------------------------------------------------
    # Terminal multiplexer
    # default-shell is fish; keep login shell change separate (chsh).
    # -------------------------------------------------------------------------
    tmux = {
      enable = true;
      mouse = true;
      newSession = true;
      shell = "${pkgs.fish}/bin/fish";
      plugins = with pkgs.tmuxPlugins; [
        resurrect
      ];
    };

    # -------------------------------------------------------------------------
    # Directory jumper — `cd` is remapped to zoxide
    # -------------------------------------------------------------------------
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };

  # ---------------------------------------------------------------------------
  # Fish completions
  # Generated at `home-manager switch` time (avoids sourcing CLIs on shell start).
  # ---------------------------------------------------------------------------
  xdg.configFile."fish/completions/gh.fish".source =
    pkgs.runCommand "gh-fish-completion" { nativeBuildInputs = [ pkgs.gh ]; } ''
      gh completion -s fish > $out
    '';

  xdg.configFile."fish/completions/tailscale.fish".source =
    pkgs.runCommand "tailscale-fish-completion" { nativeBuildInputs = [ pkgs.tailscale ]; } ''
      tailscale completion fish > $out
    '';

  # ---------------------------------------------------------------------------
  # Extra packages (not covered by programs.*.enable above)
  # ---------------------------------------------------------------------------
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

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
