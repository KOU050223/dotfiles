{ pkgs, ... }:
{
  # Nixpkgs設定
  nixpkgs.hostPlatform = "aarch64-darwin";

  # プライマリユーザー設定（nix-darwin 新要件）
  system.primaryUser = "uozumikouhei";

  # Determinate Nix を使用しているため nix-darwin のNix管理を無効化
  nix.enable = false;

  # システムパッケージ（全ユーザー共通）
  environment.systemPackages = with pkgs; [
    git
    zsh-syntax-highlighting
  ];

  # Homebrew管理（Caskアプリはここで管理）
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };
    brews = [
      # 移行後も brew で管理するもの（nixpkgsにないもの等）
      # "some-brew-only-tool"
    ];
    casks = [
      "android-studio"
      "flutter"
      "ghostty"
      "postman"
      "libreoffice"
    ];
  };

  # macOSシステム設定
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # カラムビュー
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
    };
    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadThreeFingerDrag = true;
    };
  };

  # zshをシステムシェルとして有効化（/etc/zshrcを生成）
  # home-managerのprograms.zshと併用するため promptInit を無効化
  programs.zsh = {
    enable = true;
    promptInit = "";
  };

  # nix-darwin バージョン管理用（変更しない）
  system.stateVersion = 6;
}
