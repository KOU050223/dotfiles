---
argument-hint: <issue-number> [base-branch]
description: GitHubのissueから新しいworktreeを作成して作業を開始する
---

以下のタスクを実行してください:

1. `/Users/uozumikouhei/.claude/commands/worktree-issue.sh $1 ${2:-main}` を実行してworktreeを作成
2. 作成されたworktreeのパスを取得
3. そのディレクトリに移動（`cd <worktree-path>`）
4. `.issue-context.md`ファイルの内容を読み取り、issueの詳細を確認
5. issueの内容を要約して、作業を開始するための準備状況を報告

**注意事項**:
- GitHub CLI (`gh`) がインストールされている必要があります
- Git リポジトリ内で実行する必要があります
- issueにアクセスするための適切な権限が必要です

実行後、以下の情報を提供してください:
- Issue のタイトルと概要
- 作成されたブランチ名
- Worktree のパス
- 次に取るべきアクションの提案
