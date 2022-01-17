scriptencoding utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグイン管理
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" 未インストールのプラグインがあれば自動インストール
if dein#check_install()
  call dein#install()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 基本設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nobackup
set noswapfile
set history=20

" バックスペースキーでインデントや改行を削除できるように対応
set backspace=indent,eol,start

" カーソル位置を記憶する
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

" クリックボードの有効化
set clipboard+=unnamed

" マウス操作の有効化
set mouse=a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" エンコーディング
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 内部エンコーディング
set encoding=utf-8

" 出力エンコーディング
set fileencoding=utf-8

" ファイルを開く際に優先するエンコーディング
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp

" ファイルを開く際に優先する改行コード
set fileformats=unix,mac,dos

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 表示
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" カラースキーム
colorscheme molokai

" カラースキームの上書き
hi Delimiter ctermfg=245
hi Comment ctermfg=245

" ハイライト対象ファイルの追加
autocmd BufNewFile,BufRead *.thor set syntax=ruby

" 一部のマルチバイト文字を正しく認識させる
set ambiwidth=double

" カーソル行を基準にn行を視野に入れる
set scrolloff=30

" 対応する括弧をハイライト
set showmatch

" 行番号を表示
set number

" ステータスラインの有効化
set laststatus=2

" ステータスラインにファイルの情報を表示
set statusline=%F%m%r%h%w\%=\[FORMAT=%{&ff}]\[ENC=%{&fileencoding}]\[LOW=%l/%L]

" 1行辺りの解析文字数 (長い文字列でVimが遅くなる現象を回避)
set synmaxcol=384

" PHPのショートタグをハイライトから除外
let php_noShortTags = 1

" <Ctrl+n>:行番号表示の切り替え
function Setnumber()
  if &number
    setlocal nonumber
  else
    setlocal number
  endif
endfunction
nnoremap <silent> <C-n> :call Setnumber()<CR>

" CSVデリミタをカンマで表示
let g:csv_no_conceal =1

" Go言語
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 編集
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 改行時に前の行に合わせてインデントを行う
set smartindent

" シフトオペレータで挿入するインデント幅
set shiftwidth=2

" <TAB>キーのインデント幅
set tabstop=2

" <TAB>キーでスペースを挿入
set expandtab

" 範囲インデント適用後も選択範囲を有効化
vnoremap < <gv
vnoremap > >gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 検索
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" インクリメンタルサーチの有効化
set incsearch

" 検索にマッチするすべてのキーワードをハイライト化
set hlsearch

" 大文字・小文字の違いを無視する
set ignorecase

" 大文字を含めた検索時は大文字・小文字を区別する
set smartcase
