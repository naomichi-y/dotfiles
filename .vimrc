scriptencoding utf-8

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

" PHPのショートタグをハイライトから除外
let php_noShortTags = 1

" <F2>:行番号表示の切り替え
function Setnumber()
  if &number
    setlocal nonumber
  else
    setlocal number
  endif
endfunction
nnoremap <silent> <F2> :call Setnumber()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" airblade/vim-gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bronson/vim-trailing-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight ExtraWhitespace ctermbg=8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" thinca/vim-zenspace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 全角スペースを視覚化
let g:zenspace#default_mode = 'on'

" 全角スペースの色
highlight default ZenSpace ctermbg=23

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 編集
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 改行時に前の行に合わせてインデントを行う
set smartindent

" シフトオペレータで挿入するインデント幅
set shiftwidth=2

" TABキーのインデント幅
set tabstop=2

" <tab>キーでスペースを挿入
set expandtab

" クリップボードからのペーストを有効化
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

" 範囲インデント適用後も選択範囲を有効化
vnoremap < <gv
vnoremap > >gv

" ファイル保存時に行末の空白を削除
autocmd BufWritePre * :%s/\s\+$//e

" ファイル保存時にタブをスペースに変換
"autocmd BufWritePre * :%s/\t/  /ge

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 操作
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Anywhere SID.
" function! s:SID_PREFIX()
"   return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
" endfunction
"
" " Set tabline.
" function! s:my_tabline()  "{{{
"   let s = ''
"   for i in range(1, tabpagenr('$'))
"     let bufnrs = tabpagebuflist(i)
"     let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
"     let no = i  " display 0-origin tabpagenr.
"     let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
"     let title = fnamemodify(bufname(bufnr), ':t')
"     let title = '[' . title . ']'
"     let s .= '%'.i.'T'
"     let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
"     let s .= no . ':' . title
"     let s .= mod
"     let s .= '%#TabLineFill# '
"   endfor
"   let s .= '%#TabLineFill#%T%=%#TabLine#'
"   return s
" endfunction "}}}
" let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
" set showtabline=2 " 常にタブラインを表示
"
" " The prefix key.
" nnoremap    [Tag]   <Nop>
" nmap    t [Tag]
" " Tab jump
" for n in range(1, 9)
"   " 'T1'で1番左のタブ、'T2'で1番左から2番目のタブにジャンプ
"   execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
" endfor
"
" " 'TC': 新しいタブを一番右に作る
" map <silent> [Tag]c :tablast <bar> tabnew<CR>
"
" " 'TX': タブを閉じる
" map <silent> [Tag]x :tabclose<CR>
"
" " 'TN': 次のタブ
" map <silent> [Tag]n :tabnext<CR>
"
" " 'TP': 前のタブ
" map <silent> [Tag]p :tabprevious<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグインマネージャ
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &compatible
  set nocompatible
endif
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

call dein#add('Shougo/neocomplete.vim', { 'on_i': 1 })
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('tomasr/molokai')
call dein#add('tComment')
call dein#add('Syntastic')
call dein#add('scrooloose/nerdtree')
call dein#add('embear/vim-localvimrc')
call dein#add('Yggdroot/indentLine')
" call dein#add('airblade/vim-gitgutter')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('thinca/vim-zenspace')
call dein#add('vim-scripts/AnsiEsc.vim')
call dein#add('elzr/vim-json')
call dein#add('hashivim/vim-terraform')

call dein#end()

if dein#check_install()
  call dein#install()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shougo/neocomplete
"   * neocomplete.vimの実行にはVimのluaを有効化しておく
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 起動時にプラグインを有効化
let g:neocomplete#enable_at_startup = 1

" 補完を開始する文字数
let g:neocomplete#auto_completion_start_length = 3

" 補完検索時に大文字・小文字を無視する
let g:neocomplete#enable_ignore_case = 1

" 大文字が入力された場合に大文字・小文字を区別する
let g:neocomplete#enable_smart_case = 1

" <enter>で補完を確定
function! s:my_crinsert()
  return pumvisible() ? neocomplete#close_popup() : "\<Cr>"
endfunction
inoremap <silent> <CR> <C-R>=<SID>my_crinsert()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shougo/neomru.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ファイルの更新時間を表示
let g:neomru#time_format = "(%Y/%m/%d %H:%M:%S) "

" 'F3': 最近開いたファイルの一覧を表示
nnoremap <F3> :Unite<Space>file_mru<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tomasr/molokai
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on

" 1行辺りの解析文字数 (長い文字列でVimが遅くなる現象を回避)
set synmaxcol=160

" JSONのダブルクォートが非表示になる機能を無効化
let g:vim_json_syntax_conceal = 0

" 適用するカラースキーム
colorscheme molokai

" ハイライト対象ファイルの追加
autocmd BufNewFile,BufRead *.thor set syntax=ruby
autocmd BufNewFile,BufRead *.eye set syntax=ruby

" カラースキームのオーバーライド
hi Delimiter ctermfg=245
hi Comment ctermfg=245

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tComment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" <c>: 選択範囲をコメントアウト (またはアンコメント)
let g:tcommentMapLeaderOp1 = 'c'

autocmd FileType tf setlocal commentstring=#\ %s
autocmd FileType Dockerfile setlocal commentstring=#\ %s

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': ['php', 'ruby', 'javascript', 'json'],
  \ 'passive_filetypes': []
  \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" scrooloose/nerdtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 隠しファイルを表示
let NERDTreeShowHidden = 1

" <F4>: ファイルリストを開く
nnoremap <F4> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" embear/vim-localvimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ローカル.vimrcを自動で読み込む
let g:localvimrc_persistent=2

" ローカル.vimrcを有効化
let g:localvimrc_sandbox=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Yggdroot/indentLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" インデントの深さを表す色
let g:indentLine_color_term = 239

" <F1>: 無効化・有効化の切り替え
nnoremap <F1> :IndentLinesToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bronson/vim-trailing-whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
highlight ExtraWhitespace ctermbg=8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" thinca/vim-zenspace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 全角スペースを視覚化
let g:zenspace#default_mode = 'on'

" 全角スペースの色
highlight default ZenSpace ctermbg=23

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" hashivim/vim-terraform
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terraformが必要
let g:terraform_fmt_on_save = 1
