---
name: viteplus
description: Vite+（vp）の使用方法ガイド。インストール、プロジェクト作成、開発サーバー、ビルド、テスト、依存関係管理など、vpコマンドの包括的なリファレンス。ユーザーがVite+の使い方を聞いたとき、またはvpコマンドに関する質問をしたときに使用する。
---

# Vite+ (vp) 使用ガイド

Vite+は、Vite・Vitest・Oxlint・Oxfmt・Rolldown・tsdown・Vite Taskを統合したウェブ開発ツールチェーン。ランタイム、パッケージマネージャー、フロントエンド開発環境を1つのプラットフォームで管理する。

公式ドキュメント: https://viteplus.dev/guide/

## インストール

### macOS / Linux
```bash
curl -fsSL https://vite.plus | bash
```

### Windows (PowerShell)
```powershell
irm https://vite.plus/ps1 | iex
```

インストール後、`vp help` でコマンド一覧を確認できる。

## クイックスタート（基本的な開発フロー）

```bash
vp create     # プロジェクト作成
vp install    # 依存関係インストール
vp dev        # 開発サーバー起動
vp check      # フォーマット・リント・型チェック
vp test       # テスト実行
vp build      # 本番ビルド
```

---

## コマンドリファレンス

### Start（プロジェクト開始）

| コマンド | 説明 |
|---------|------|
| `vp create` | 新しいアプリ・パッケージ・モノレポを作成 |
| `vp migrate` | 既存プロジェクトをVite+に移行 |
| `vp config` | コミットフックとエージェント統合を設定 |
| `vp staged` | ステージングされたファイルでチェックを実行 |
| `vp install` | 適切なパッケージマネージャーで依存関係をインストール |
| `vp env` | Node.jsバージョンを管理 |

### Develop（開発）

| コマンド | 説明 |
|---------|------|
| `vp dev` | Viteで開発サーバーを起動 |
| `vp check` | フォーマット・リント・型チェックを一括実行 |
| `vp lint` | リント実行（Oxlint） |
| `vp fmt` | フォーマット実行（Oxfmt） |
| `vp test` | JavaScriptテストを実行（Vitest） |

### Execute（実行）

| コマンド | 説明 |
|---------|------|
| `vp run` | ワークスペース全体でタスクを実行（キャッシング対応） |
| `vp cache` | タスクキャッシュエントリをクリア |
| `vpx` | バイナリをグローバルに実行 |
| `vp exec` | ローカルプロジェクトバイナリを実行 |
| `vp dlx` | パッケージバイナリを依存関係なしで実行 |

### Build（ビルド）

| コマンド | 説明 |
|---------|------|
| `vp build` | アプリを本番ビルド（Rolldown/Vite） |
| `vp pack` | ライブラリまたはスタンドアロンアーティファクトをビルド（tsdown） |
| `vp preview` | 本番ビルドをローカルでプレビュー |

### Manage Dependencies（依存関係管理）

| コマンド | 説明 |
|---------|------|
| `vp add <pkg>` | 依存関係を追加 |
| `vp remove <pkg>` | 依存関係を削除 |
| `vp update` | 依存関係を更新 |
| `vp dedupe` | 重複を排除 |
| `vp outdated` | 古い依存関係を表示 |
| `vp why <pkg>` | 依存関係が必要な理由を表示 |
| `vp info <pkg>` | パッケージ情報を表示 |
| `vp pm <command>` | パッケージマネージャーコマンドを直接呼び出し |

### Maintain（メンテナンス）

| コマンド | 説明 |
|---------|------|
| `vp upgrade` | vp自体を最新版に更新 |
| `vp implode` | マシンからVite+を削除 |
| `vp help` | ヘルプを表示 |

---

## 統合ツール

Vite+は以下のツールを統合している：

- **Vite** — 高速な開発サーバーとビルドツール
- **Vitest** — Viteネイティブなテストランナー（`vp test`）
- **Oxlint** — 高速なRustベースのリンター（`vp lint`）
- **Oxfmt** — Rustベースのフォーマッター（`vp fmt`）
- **Rolldown** — RustベースのバンドラーでRollupの後継（`vp build`）
- **tsdown** — TypeScriptライブラリのビルドツール（`vp pack`）
- **Vite Task** — タスクランナー（`vp run`）

## ユースケース別ガイド

### 新しいプロジェクトを始める
```bash
vp create my-app
cd my-app
vp install
vp dev
```

### 既存プロジェクトをVite+に移行する
```bash
cd existing-project
vp migrate
```

### Node.jsバージョンを切り替える
```bash
vp env          # バージョン一覧・選択
vp env off      # グローバルNode.js管理をオフ
```

### ライブラリをパッケージ化する
```bash
vp pack
```

### コードの品質チェック
```bash
vp check        # fmt + lint + 型チェックを一括実行
vp lint         # リントのみ
vp fmt          # フォーマットのみ
```
