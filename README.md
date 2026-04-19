# dotfiles

[chezmoi](https://www.chezmoi.io/) で管理している個人のdotfilesです。

## 管理対象ファイル

| ファイル | 説明 |
|----------|------|
| `.zshrc` | Zsh 設定 |
| `.bashrc` | Bash 設定 |
| `.gitconfig` | Git グローバル設定 |

## セットアップ（新しいマシン）

### 1. chezmoi インストール

**macOS (Homebrew)**
```bash
brew install chezmoi
```

**Linux / その他**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### 2. dotfiles を適用

```bash
chezmoi init --apply https://github.com/KOU050223/dotfiles.git
```

これ1コマンドで clone → 適用まで完了します。

---

## 日常的な使い方

### ファイルを新たに管理対象に追加

```bash
chezmoi add ~/.vimrc
```

### 編集する

```bash
chezmoi edit ~/.zshrc
```

### 差分を確認する

```bash
chezmoi diff
```

### ホームディレクトリに適用する

```bash
chezmoi apply
```

### GitHubに同期する

```bash
chezmoi cd
git add -A
git commit -m "..."
git push
```

または1行で：

```bash
chezmoi cd && git add -A && git commit -m "update dotfiles" && git push
```

### リモートの変更を取り込む

```bash
chezmoi update
```

---

## ディレクトリ構成

chezmoi のソースディレクトリは `~/.local/share/chezmoi/` です。

ファイル名のプレフィックスルール：

| プレフィックス | 意味 |
|----------------|------|
| `dot_` | `.`（ドット）に変換される |
| `executable_` | 実行権限が付与される |
| `private_` | パーミッション 600 で作成される |

例: `dot_zshrc` → `~/.zshrc`
