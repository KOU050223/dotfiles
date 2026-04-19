{ pkgs, lib, ... }:
{
  home.username = "uozumikouhei";
  home.homeDirectory = lib.mkForce "/Users/uozumikouhei";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # --- Go ---
    go
    golangci-lint

    # --- Node / JS ---
    nodejs_22
    pnpm
    deno

    # --- Python ---
    uv
    pyenv

    # --- Ruby ---
    rbenv

    # --- Rust ---
    rustup

    # --- Cloud / Infra ---
    awscli2

    # --- CLI ツール ---
    gh
    ghq
    ripgrep
    fd
    bat
    fzf
    direnv
    jq
    tree
    wget
    curl
    tmux
    neovim

    # --- Git拡張 ---
    git-lfs

    # --- その他 ---
    starship
    chezmoi
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "KOU050223";
      user.email = "kouhei20050223@icloud.com";
      core.autocrlf = "input";
      push.autoSetupRemote = true;
      ghq.root = "/Users/uozumikouhei/workspace";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      # nix-darwinのPATH設定を確実に読み込む
      if [ -z "$__NIX_DARWIN_SET_ENVIRONMENT_DONE" ]; then
        . /etc/zshenv
      fi
    '';
    initContent = ''
      # Kiro CLI
      [[ -f "''${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "''${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

      # Node version manager (nvm)
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

      # Google Cloud SDK
      if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
      if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

      # pyenv
      export PYENV_ROOT="$HOME/.pyenv"
      if command -v pyenv &>/dev/null; then eval "$(pyenv init -)"; fi

      # rbenv
      if command -v rbenv &>/dev/null; then eval "$(rbenv init -)"; fi

      # その他PATH
      export PATH="$HOME/.pub-cache/bin:$PATH"
      export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
      export PATH="$HOME/.progate/bin:$PATH"
      export PATH="/usr/local/mysql/bin:$PATH"
      export PATH="$HOME/go/bin:$PATH"
      export PATH="$HOME/.tiup/bin:$PATH"
      export PATH="$HOME/.ticloud/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/bin:$PATH"

      # Kiro CLI (post)
      [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
      [[ -f "''${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "''${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

      # aliases
      alias g='git'
      alias gitprune="git fetch --prune && git branch -vv | grep ': gone]' | awk '{print \$1}' | xargs git branch -D"
      alias newtarm='newtab'
      alias dbx='devbox'

      # uv補完
      eval "$(uv generate-shell-completion zsh)"

      # カスタム補完
      fpath=(~/.zsh/completions \$fpath)
      [[ -f ~/.zsh/completions/_git-gtr ]] && source ~/.zsh/completions/_git-gtr

      # unicli補完
      _unicli_completions() {
        local -a candidates
        candidates=("''${(@f)$(unicli complete "''${words[*]}" 2>/dev/null)}")
        compadd -a candidates
      }
      compdef _unicli_completions unicli

      # Vite+
      [ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

      # ghcup
      [ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

      # newtab関数
      newtab() {
        local target
        if [ -n "$1" ]; then
          target="$(cd "$1" 2>/dev/null && pwd)" || { echo "no such directory: $1" >&2; return 1; }
        else
          target="$PWD"
        fi
        osascript <<OSASCRIPT
      tell application "Terminal"
        activate
        tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
        do script "cd '$target'" in front window
      end tell
      OSASCRIPT
      }

      # cdf関数
      unalias cdf 2>/dev/null
      cdf() {
        local dir
        dir=$(fd --type d 2>/dev/null | fzf +m --preview 'tree -C {} | head -200')
        [[ -n $dir ]] && cd "$dir"
      }
    '';
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
  ];
}
