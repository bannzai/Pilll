---
paths:
  - "supabase/**/*.sql"
  - "**/supabase/**/*.sql"
---

# Supabase の関数権限は anon への明示 REVOKE と実測で守る

Supabase の SQL (migrations) で関数を作成・変更する時のルール。認証必須の RPC が anon (未認証) から実行できる穴を防ぐ (実例: Resumemo で認証必須 RPC が anon から実行できていた https://github.com/bannzai/Resumemo/issues/88 / https://github.com/bannzai/Resumemo/pull/89 )。

## ルール

- `REVOKE ALL ON FUNCTION ... FROM PUBLIC` だけで anon を塞いだと判断しない。PUBLIC 宛の REVOKE は PUBLIC 疑似ロールの権限しか剥がさず、Supabase は postgres ロール (migration の実行ロール) の既定権限 (pg_default_acl) で public スキーマの新規関数に anon へ EXECUTE を直接付与するため、anon から実行できる状態が残る (Resumemo 本番で実測)。認証必須の関数は `REVOKE ALL ON FUNCTION <signature> FROM anon;` を明示する
- 既定権限を止める時は `ALTER DEFAULT PRIVILEGES` をグローバル (`IN SCHEMA` なし) で REVOKE する。`IN SCHEMA` 付きの既定権限はグローバル既定への「追加」しか表現できず、`IN SCHEMA` 付きの REVOKE では PostgreSQL 組み込み既定 (新規関数への PUBLIC EXECUTE 付与) を打ち消せない (supabase local で実測)

```sql
-- IN SCHEMA 付き REVOKE 後に関数を作成 → anon が実行できてしまう (proacl: NULL)
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

-- グローバル REVOKE 後に関数を作成 → anon は実行できない (proacl: {postgres=X/postgres})
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
```

- anon ロールは「anon key (publishable key) だけを持つ未認証リクエスト」。anon key は JS バンドルに含まれ誰でも取得できるため、認証必須の RPC を anon に開かない。Supabase の匿名認証 (`signInAnonymously`) は JWT の role が `authenticated` になる (`is_anonymous` claim で区別) ので、anon から EXECUTE を剥がしても匿名認証ユーザーの動作には影響しない
- 認証必須の関数は、関数内の `auth.uid()` チェック (アプリ層) と GRANT / REVOKE (権限層) の二段で守る。片方だけだと、書き忘れた瞬間に無認証で実行できる穴になる。新規関数は開きたいロールへ明示的に `GRANT EXECUTE` し、既定付与に依存しない
- 権限変更は実測で検証する。PostgREST 経由で anon key を使い RPC を直接 POST し、権限エラー (HTTP 401/403、PostgreSQL error code `42501` permission denied) で「関数本体に到達しない」ことを確認する。関数内チェックのエラー (400 等) は「関数が実行されている」ことを意味し、権限層の防御にはなっていない

参照: https://www.postgresql.org/docs/current/sql-alterdefaultprivileges.html / https://supabase.com/docs/guides/database/functions
実例: https://github.com/bannzai/Resumemo/issues/88 / https://github.com/bannzai/Resumemo/pull/89
