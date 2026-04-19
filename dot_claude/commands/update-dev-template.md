---
allowed-tools: Bash(git *), Read, Edit, Write, Glob, Grep
description: 現在の開発プロジェクトから学んだ改善点を ~/workspace/dev-template に反映してテンプレートを育てる
---

## コンテキスト

- 現在のプロジェクト: !`pwd`
- テンプレートリポジトリ: `~/workspace/dev-template`
- テンプレートの現在の状態:
  !`ls ~/workspace/dev-template`

## タスク

現在の開発プロジェクトで使われている設定・パターンを分析し、`~/workspace/dev-template` を改善してください。

### Step 1: 現在のプロジェクトを分析する

以下のファイルを確認し、テンプレートに取り込む価値のある改善点を探す:

- `lefthook.yml` — より良い hooks 設定があるか
- `oxlint.json` / `oxfmt.toml` — ルール追加・設定改善があるか
- `devbox.json` — パッケージ構成に新しいパターンがあるか
- `.github/workflows/` — CI の改善パターンがあるか
- `package.json` の `scripts` — 便利なスクリプトがあるか
- `docs/` やコメント — ドキュメントの改善点があるか

### Step 2: 改善提案をまとめる

分析結果をもとに、以下を判断してください:

1. **そのままコピーすべき変更** — バグ修正、バージョンアップ、普遍的な改善
2. **参考にして汎用化すべき変更** — プロジェクト固有の設定を汎用テンプレート向けに調整
3. **テンプレートには不要な変更** — プロジェクト固有すぎるもの

### Step 3: ユーザーに確認してから反映

変更内容を提示して確認を取り、承認されたものだけ `~/workspace/dev-template` に反映する。

### Step 4: テンプレートにコミット & push

```
cd ~/workspace/dev-template
git add <変更ファイル>
git commit -m "chore: <変更内容の要約>"
git push
```

---

**注意:**
- テンプレートはあくまで「汎用的な出発点」なので、プロジェクト固有の設定は入れない
- `package.json` の `dev` / `build` / `test` スクリプトは `echo 'TODO: ...'` のままにする
- devbox パッケージは最小構成 (`nodejs@24` + `lefthook@latest`) を維持し、追加例は `docs/devbox.md` に記載する
