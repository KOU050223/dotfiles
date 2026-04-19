# dotfiles

[chezmoi](https://www.chezmoi.io/) + [nix-darwin](https://github.com/LnL7/nix-darwin) + [Home Manager](https://github.com/nix-community/home-manager) で管理している個人のdotfilesです。

- **パッケージ管理**: nix-darwin + Home Manager
- **dotfiles管理**: chezmoi（段階的にHome Managerへ移行予定）
- **対象OS**: macOS (Apple Silicon)

---

## セットアップ（新しいマシン）

### 1. Determinate Nix をインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

インストール後、ターミナルを再起動する。

### 2. dotfiles リポジトリを clone

```bash
git clone https://github.com/KOU050223/dotfiles.git ~/.local/share/chezmoi
```

### 3. nix-darwin + Home Manager を適用

```bash
sudo nix run nix-darwin -- switch --flake ~/.local/share/chezmoi/nix#uozumikouhei-mac
```

初回は10〜20分かかります。完了後、新しいターミナルを開く。

### 4. chezmoi で dotfiles を適用

```bash
chezmoi apply
```

### 5. VSCode 拡張機能を一括インストール

```bash
cat ~/.local/share/chezmoi/vscode-extensions.txt | xargs -I {} code --install-extension {}
```

---

## 日常的な使い方

### パッケージを追加・変更する

**1. パッケージ名を調べる**

```bash
nix search nixpkgs パッケージ名
```

または https://search.nixos.org/packages で検索。

**2. 何をどこに書くか**

| 追加したいもの | 編集するファイル | 書く場所 |
|----------------|-----------------|----------|
| CLIツール（go, gh, jq等） | `home.nix` | `home.packages` |
| シェル設定・エイリアス | `home.nix` | `programs.zsh.initContent` |
| macOS GUIアプリ | `darwin.nix` | `homebrew.casks` |
| nixpkgsにないCLIツール | `darwin.nix` | `homebrew.brews` |

**3. 適用してGitHubに保存**

```bash
# 適用
sudo darwin-rebuild switch --flake ~/.local/share/chezmoi/nix#uozumikouhei-mac

# GitHubに保存
cd ~/.local/share/chezmoi && git add -A && git commit -m "feat: add xxx" && git push
```

### macOS設定を変更する

`nix/modules/darwin.nix` を編集して適用（上記と同じコマンド）。

### dotfiles を編集・同期する

```bash
# ファイルを編集
chezmoi edit ~/.zshrc

# 適用
chezmoi apply

# GitHubに同期
chezmoi cd && git add -A && git commit -m "update" && git push
```

### リモートの変更を取り込む

```bash
chezmoi update
sudo darwin-rebuild switch --flake ~/.local/share/chezmoi/nix#uozumikouhei-mac
```

---

## 管理対象ファイル

### nix（パッケージ・システム設定）

| ファイル | 説明 |
|----------|------|
| `nix/flake.nix` | nixpkgs・nix-darwin・Home Manager のエントリ |
| `nix/modules/darwin.nix` | nix-darwin システム設定（Dock, Finder, Homebrew Cask等） |
| `nix/modules/home.nix` | Home Manager 設定（パッケージ一覧・zshrc・gitconfig等） |

### chezmoi（dotfiles）

| ファイル | 説明 |
|----------|------|
| `.zshrc` | Zsh 設定 |
| `.bashrc` | Bash 設定 |
| `.gitconfig` | Git グローバル設定 |
| `.config/starship.toml` | Starship プロンプト設定 |
| `.config/ghostty/` | Ghostty ターミナル設定 |
| `.config/gh/` | GitHub CLI 設定 |
| `.claude/` | Claude Code グローバル設定・コマンド・スキル |
| `.agents/` | Claude エージェントスキル実体 |
| `Library/Application Support/Code/User/settings.json` | VSCode 設定 |
| `Library/Application Support/Code/User/keybindings.json` | VSCode キーバインド |
| `vscode-extensions.txt` | VSCode 拡張機能一覧 |

---

## ディレクトリ構成

```
~/.local/share/chezmoi/   （= ~/workspace/dotfiles-nix はnix/へのシンボリックリンク）
├── nix/
│   ├── flake.nix
│   ├── flake.lock
│   └── modules/
│       ├── darwin.nix
│       └── home.nix
├── dot_zshrc
├── dot_gitconfig
├── dot_config/
│   ├── starship.toml
│   └── ghostty/
├── dot_claude/
├── dot_agents/
├── dot_vscode/
├── private_Library/
└── vscode-extensions.txt
```

chezmoi のファイル名プレフィックスルール：

| プレフィックス | 意味 |
|----------------|------|
| `dot_` | `.`（ドット）に変換される |
| `executable_` | 実行権限が付与される |
| `private_` | パーミッション 600 で作成される |
