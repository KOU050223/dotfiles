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
    google-cloud-sdk
    kubectl
    docker
    terraform

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
    ni
    
    # --- Git拡張 ---
    git-lfs

    # --- その他 ---
    starship
    zsh-syntax-highlighting
    chezmoi
    lefthook
  ];

  # nixpkgsにないツール（手動インストール）
  # 新しいマシンでは以下を実行:
  #
  # [npm global] nvmのv22で管理
  # npm install -g firebase-tools ccusage cloudflare-bulk-delete @qiita/qiita-cli cz-git czg @anthropic-ai/claude-code
  #
  # [curl install]
  # curl -fsSL https://cli.coderabbit.ai/install.sh | sh  # → ~/.local/bin/coderabbit
  # curl -fsSL https://claude.ai/install.sh | bash

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

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
  ];
}
