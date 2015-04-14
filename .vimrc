scriptencoding utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 一般
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

" バックスペースでインd年とや改行を削除できるようにする
set backspace=indent,eol,start

" 前回閉じた行位置を記憶する
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" エンコーディングと改行コード
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

" 文字列をペーストした際にインデントを無効にする
set paste

" 範囲インデント変更後も選択を継続する
vnoremap < <gv
vnoremap > >gv

" 行末の空白を保存時に削除
autocmd BufWritePre * :%s/\s\+$//e

" 保存時にタブをスペースに変換
autocmd BufWritePre * :%s/\t/  /ge

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 操作
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 次のタブに移動
map <C-n> :tabn <Enter>

" 前のタブに移動
map <C-p> :tabp <Enter>

" バッファを閉じる
"map <C-e> :q!<Enter>

" バッファ移動
map <C-LEFT> <ESC>:bp!<CR>
map <C-RIGHT> <ESC>:bn!<CR>

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
" Neo Bundle (https://github.com/Shougo/neobundle.vim)
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
" Neo Bundle Plugins
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
NeoBundle 'Smooth-Scroll'
NeoBundle 'scrooloose/nerdtree'
"NeoBundle 'buftabs'
"NeoBundle 'git://github.com/Shougo/neocomplcache.git'
"NeoBundle 'git://github.com/Shougo/neocomplcache-snippets-complete.git'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme
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
" tComment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 選択範囲をコメントアウト
let g:tcommentMapLeaderOp1 = 'c'

" 選択範囲をアンコメント
let g:tcommentMapLeaderOp2 = 'C'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': ['php'],
  \ 'passive_filetypes': ['html'] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yanktmp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"map <silent> ,sy :call YanktmpYank()<CR>
"map <silent> ,sp :call YanktmpPaste_p()<CR>
"map <silent> ,sP :call YanktmpPaste_P()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neomru.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  'unite-mru'でファイルの更新時間を表示
let g:neomru#time_format = "(%Y/%m/%d %H:%M:%S) "

" 最近開いたファイルの一覧を表示
nnoremap <C-h> :Unite<Space>file_mru<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mooth-Scroll
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 設定項目は特になし

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ファイルリストを開く
nnoremap <F3> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buftabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:buftabs_only_basename=1
"let g:buftabs_in_statusline=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" プラグインの有効化
"let g:neocomplcache_enable_at_startup = 1

" ポップアップリストの長さ
"let g:neocomplcache_max_list = 20

" 日本語を補完候補として取得しない
"if !exists('g:neocomplcache_keyword_patterns')
"  let g:neocomplcache_keyword_patterns = {}
"endif
"let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" キャッシュディレクトリ
"let g:neocomplcache_temporary_dir = '/tmp/.neocon'

" 辞書
"let g:neocomplcache_dictionary_filetype_lists = {
"  \ 'php' : $HOME.'/.vim/dict/php.dict',
"  \ }

"let g:neocomplcache_manual_completion_start_length = 3000

" TABで補完
"function InsertTabWrapper()
"  if pumvisible()
"    return "\<c-n>"
"  endif
"  let col = col('.') - 1
"   if !col || getline('.')[col - 1] !~ '\k\|<\|/'
"     return "\<tab>"
"   elseif exists('&omnifunc') && &omnifunc == ''
"     return "\<c-n>"
"   else
"     return "\<c-x>\<c-o>"
"   endif
" endfunction
" inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache-snippets-complete.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" スニペットを展開するキーマッピング
"imap <C-k> <Plug>(neocomplcache_snippets_expand)
"smap <C-k> <Plug>(neocomplcache_snippets_expand)

" 標準のスニペットを無効にする
"let g:neocomplcache_snippets_disable_runtime_snippets = 1

" ユーザスニペットの格納ディレクトリ
"let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

