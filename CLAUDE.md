# CLAUDE.md

このリポジトリ（dotfiles）を変更・リファクタリングする際のベース規約。

## リポジトリの仕組み

- `src/` 配下が `$HOME` のディレクトリ構成を反映する。例: `src/.zshrc` → `~/.zshrc`、`src/.config/nvim/` → `~/.config/nvim/`。
- 配置は `setup.sh` が **symlink** で行う（`ln -s`）。`~/.config/nvim` 等はリポジトリへの symlink なので、`src/` を編集すれば即座に実環境へ反映される（再デプロイ不要）。
  - 例外: `.env` のみ `cp`（symlink ではない）。
- `Brewfile` も symlink（`~/Brewfile`）。Homebrew で入れるツールの一次情報源。

## 鉄則: 設定が依存するツールは必ず Brewfile に書く

- 設定ファイル（vim プラグイン・zsh・各種 CLI）が外部コマンドに依存する場合、そのコマンドを **必ず `src/Brewfile` に追記**する。
- Brewfile に無いツールは `brew bundle` で復元されず、環境移行・OS 再セットアップ時に「設定はあるのに動かない」状態を生む。
- 過去事例: `deno` 欠落で nvim の補完（denops）が全停止した。設定の追加時は依存ツールの追記をセットで行うこと。

## Neovim プラグイン管理（dein）

- `src/.config/nvim/dein.toml` = 起動時ロード、`dein_lazy.toml` = 遅延ロード（`init.vim` が `{'lazy': 1}` で読む）。
- **toml を変更したら dein のキャッシュ state を必ずクリアする**: `nvim --headless -c 'call dein#clear_state()' -c 'qa!'`。クリアしないと `on_event` / `hook_source` 等の変更が反映されない。
- 遅延プラグインは `on_event` / `on_source` / `on_func` などのトリガーが無いと自動ロードされない。トリガー無しのエントリは「ロードされない」前提で疑う。

## 補完スタック（ddc + denops）の規約

このスタックは依存関係が多く壊れやすい。変更時は以下を満たすこと。

1. **denops は Deno 必須** — `brew "deno"` を Brewfile に保持する。
2. **遅延ロードの denops はサーバーを明示起動する** — `denops.vim` を遅延ロードする場合、`VimEnter` を過ぎているため自動起動しない。`hook_source` で `call denops#server#connect_or_start()` を明示的に呼ぶ（`on_event` を付けるだけでは起動しない。検証済み）。
3. **ddc は表示 UI プラグインが必須** — 新しい ddc は候補表示 UI が分離されている。UI が無いと `[denops] Not found ui` となり候補が画面に出ない。`Shougo/ddc-ui-native` を入れ、`call ddc#custom#patch_global('ui', 'native')` を設定する。
4. **`sources` に列挙する名前は、実際にインストール済みのプラグインが登録する source 名と一致させる** — 不一致や実体の無いソースは `[ddc] Not found source: xxx` になる。
   - 注意した変更点: `nvim-lsp` は `ddc-source-lsp` への改名で source 名が **`lsp`** に変わった。`vsnip` は ddc ソースの実体が無い（`vim-vsnip-integ` はスニペット展開専用でソースを提供しない）ため列挙しない。
5. **対応プラグインが無いソースは列挙しない**。将来 LSP 補完を使うなら `lsp` ソース＋LSP クライアント（nvim-lspconfig 等）をセットで導入する。クライアント未設定の `lsp` ソースは候補を出さない（エラーにはならない）。

## 動作確認の方法（ヘッドレス）

- denops 起動確認: `nvim --headless` で挿入モードに入れる（`feedkeys("ifoo\<Esc>", "x")`）→ ループで `denops#server#status()` が `running` になるまでポーリング。
- Deno の初回依存ダウンロード中は `starting` で固まる。事前に `deno cache <entrypoint>` でキャッシュさせると解消する。
- 補完候補のポップアップ表示はヘッドレスでは観測しにくい（`complete()` が denops 非同期コールバック内で走るため）。**最終的な候補表示の確認は実機の対話 nvim で行う**こと。

## 変更後のチェックリスト

- [ ] 追加した設定の依存ツールを `Brewfile` に書いたか
- [ ] dein toml を変更したなら `dein#clear_state()` を実行したか
- [ ] 新規プラグインは `dein#install()` で取得したか
- [ ] symlink 経由なので `src/` の編集が実環境に反映されることを前提にしたか
- [ ] 不要になった処理・実体の無い設定を残していないか
