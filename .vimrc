scriptencoding utf-8

set runtimepath+=~/.vim
runtime! autoload/*.conf

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 基本設定
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" バックアップを取らない
set nobackup

" スワップファイルを作成しない
set noswapfile

" コマンド履歴の保持数
set history=20

" Vimを閉じてもカーソル位置を記憶する
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

" バックスペースキーでインデントや改行を削除できるように対応
set backspace=indent,eol,start

" 前回閉じた行位置を記憶する
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview

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
" シンタックスのハイライト
syntax on

augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces ctermbg=8
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" 一部のマルチバイト文字を正しく認識させる
set ambiwidth=double

" 常にカーソル位置から指定行数を空ける
set scrolloff=20

" 対応する括弧を表示
set showmatch

" 行番号を非表示にする
set nonumber

" ステータスラインにエンコーディングや改行コード情報を表示
set statusline=%F%m%r%h%w\%=\[FORMAT=%{&ff}]\[ENC=%{&fileencoding}]\[LOW=%l/%L]

" 'statusline'の情報を常にステータスラインに表示
set laststatus=2

" PHPのショートタグをハイライトから除外する
let php_noShortTags = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 操作
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  " 'T1'で1番左のタブ、'T2'で1番左から2番目のタブにジャンプ
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" 'TC': 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>

" 'TX': タブを閉じる
map <silent> [Tag]x :tabclose<CR>

" 'TN': 次のタブ
map <silent> [Tag]n :tabnext<CR>

" 'TP': 前のタブ
map <silent> [Tag]p :tabprevious<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 編集
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 高度なインデント
set smartindent

" シフトオペレータのインデント数
set shiftwidth=2

" タブの移動量
set tabstop=2

" TABキー押下時にスペースを挿入
set expandtab

" クリップボードからのペーストを有効にする
" (単に'set paste'を指定すると、vim-smartinputプラグインが動作しない問題がある)
if &term =~ "xterm"
  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>
endif

" 範囲インデント変更後も選択を継続する
vnoremap < <gv
vnoremap > >gv

" 行末の空白を保存時に削除
autocmd BufWritePre * :%s/\s\+$//e

" 保存時にタブをスペースに変換
autocmd BufWritePre * :%s/\t/  /ge

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 検索
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" インクリメンタルサーチを有効化
set incsearch

" 検索にマッチするすべてのキーワードをハイライト化
set hlsearch

" 検索時の大文字・小文字を無視する
set ignorecase

" 大文字を含めた検索時のみ大文字・小文字を区別する
set smartcase

" 検索後にファイルの先頭へループしない
"set nowrapscan

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグイン (NeoBundle)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
 if &compatible
   set nocompatible               " Be iMproved
 endif

 " Required:
 set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグイン (NeoBundle Plugins)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

NeoBundle 'tomasr/molokai'
"NeoBundle 'smartchr.vim'
"NeoBundle 'eregex.vim'
"NeoBundle 'sudo.vim'
NeoBundle 'tComment'
NeoBundle 'Syntastic'
"NeoBundle 'yanktmp.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
"Bundle 'git://github.com/tpope/vim-surround.git'
"NeoBundle 'Smooth-Scroll'
NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'buftabs'
NeoBundle 'romanvbabenko/rails.vim'
NeoBundle "kana/vim-smartinput"
NeoBundle "cohama/vim-smartinput-endwise"

NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \   'mac' : 'make -f make_mac.mak',
  \ }
  \ }
NeoBundleLazy 'supermomonga/neocomplete-rsense.vim', {
  \ 'autoload' : {
  \ 'insert' : 1,
  \ 'filetypes': 'ruby',
  \ }
  \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" molokai
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme molokai

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" smartchr
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"inoremap <buffer><expr> + smartchr#one_of(' + ', '++', ' += ')
"inoremap <buffer><expr> - smartchr#one_of(' - ', '--', ' -= ')
"inoremap <buffer><expr> / smartchr#one_of(' / ', '// ',  '/')
"inoremap <buffer><expr> * smartchr#one_of(' * ', '** ')
"inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ')
"inoremap <buffer><expr> % smartchr#one_of(' % ')
"inoremap <buffer><expr> <bar> smartchr#one_of(' <bar> ',  ' <bar><bar> ')
"inoremap <buffer><expr> , smartchr#one_of(', ', ',')
"inoremap <buffer><expr> . smartchr#one_of(' . ', '. ')
"inoremap <buffer><expr> = smartchr#one_of(' = ', ' == ', ' === ')
"inoremap <buffer><expr> { smartchr#one_of(' {<cr>')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" eregex
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sudo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tComment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 'c': 選択範囲をコメントアウト (またはアンコメント)
let g:tcommentMapLeaderOp1 = 'c'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': ['php', 'ruby', 'javascript', 'json'],
  \ 'passive_filetypes': []
  \ }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yanktmp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"map <silent> ,sy :call YanktmpYank()<CR>
"map <silent> ,sp :call YanktmpPaste_p()<CR>
"map <silent> ,sP :call YanktmpPaste_P()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" unite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neomru.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  'unite-mru'でファイルの更新時間を表示
let g:neomru#time_format = "(%Y/%m/%d %H:%M:%S) "

" 'Ctrl-H': 最近開いたファイルの一覧を表示
nnoremap <C-h> :Unite<Space>file_mru<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-surround.git
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mooth-Scroll
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nerdtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'F3': ファイルリストを開く
nnoremap <F3> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buftabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:buftabs_only_basename=1
"let g:buftabs_in_statusline=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rails
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-smartinput
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-smartinput-endwise"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 起動時にプラグインを有効化
call smartinput_endwise#define_default_rules()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if g:enable_neocomplete == 1
  " 起動時にプラグインを有効化
  let g:neocomplete#enable_at_startup = 1

  " 補完を開始する文字数
  let g:neocomplete#auto_completion_start_length = 3

  " 補完検索時に大文字・小文字を無視する
  let g:neocomplete#enable_ignore_case = 1

  " 大文字が入力された場合に大文字・小文字を区別する
  let g:neocomplete#enable_smart_case = 1
endif

" 'Enter'で補完を確定
function! s:my_crinsert()
  return pumvisible() ? neocomplete#close_popup() : "\<Cr>"
endfunction
inoremap <silent> <CR> <C-R>=<SID>my_crinsert()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete-rsense
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if g:enable_neocomplete == 1
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

  " 環境変数RSENSE_HOMEに'/usr/local/bin/rsense'を指定しても動く
  let g:neocomplete#sources#rsense#home_directory = '/usr/local/Cellar/rsense/0.3'
end
