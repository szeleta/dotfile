"vimの設定
"dein.vimの設定-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif
" Required:
set runtimepath^=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
" Required:
call dein#begin(expand('$HOME/.cache/dein'))
" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')
"----------------------------------------------------------
" Add or remove your plugins here
" ---------------------------------------------------------
" コードの自動補完
call dein#add('Shougo/neocomplete.vim')
" スニペットの補完機能
call dein#add('Shougo/neosnippet.vim')

" スニペット集
call dein#add('Shougo/neosnippet-snippets')

"ノードツリー"
call dein#add('scrooloose/nerdtree')

"rustようプラグイン"
call dein#add('rust-lang/rust.vim')

"マークダウン用プラグイン"
call dein#add('godlygeek/tabular')
call dein#add('tpope/vim-markdown')
call dein#add('kannokanno/previm')
call dein#add('tyru/open-browser.vim')

"カラースキーム"
call dein#add('tomasr/molokai')

"The end plugins-------------------------------------------
" You can specify revision/branch/tag.
call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
" Required:
call dein#end()
" Required:
filetype plugin indent on
if dein#check_install()
  call dein#install()
endif
"End dein Scripts------------------------------------------

"----------------------------------------------------------
" neocomplete・neosnippetの設定
"----------------------------------------------------------
" Vim起動時にneocompleteを有効にする
let g:neocomplete#enable_at_startup = 1
" smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplete#enable_smart_case = 1
" 3文字以上の単語に対して補完を有効にする
let g:neocomplete#min_keyword_length = 3
" 区切り文字まで補完する
let g:neocomplete#enable_auto_delimiter = 1
" 1文字目の入力から補完のポップアップを表示
let g:neocomplete#auto_completion_start_length = 1
" バックスペースで補完のポップアップを閉じる
inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
" エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
" タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"

"end prefarence--------------------------------------------
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | set mouse=a | endif
map <C-n> :NERDTreeToggle<CR>
map <F5> :PrevimOpen<CR>
nnoremap <Space>c :set foldmethod=indent<CR>:set foldmethod=syntax<CR>

" ---ここからvimの設定---
syntax enable

colorscheme molokai

highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=gray
set fileformat=unix
set encoding=utf-8
set number
" 行番号を表示

set tabstop=4
" タブを４文字にする

set sw=4
"インデントを4文字"

hi Comment ctermfg=3
" コメントの色を水色

set virtualedit=onemore
" 行末の1文字先までカーソルを移動できるように

set title
" タイトルを表示

set wildmenu wildmode=list:longest,full
" コマンドラインモードでTABキーによるファイル名補完を有効にする

set nocompatible
"viとの互換性を無効にする(INSERT中にカーソルキーが有効になる)

"カーソルを行頭，行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

set backspace=indent,eol,start
"BSで削除できるものを指定する
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字

set modeline
let perl_fold=1

"--------------------------
" emacs-key-bind (insert mode)
"--------------------------

"移動コマンド
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <Home>
imap <C-e> <End>
imap <C-g> <ESC>Gi

"削除コマンド
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-k> <ESC>C

"エスケープ
imap <silent>jj <esc>

"終了


"保存,コンパイル
imap <silent> <C-w> <ESC>:w<CR>i
imap <silent> <C-c> <ESC>:w<CR>:!platex *.tex<CR>:!platex *.tex<CR>:!dvipdfmx *.dvi<CR>i
imap <silent> <C-u> <ESC>u<CR>i

".swpを~/.vimfilesに保存
set directory=~/.vimfiles/swp

".viminfoを~/.vimfilesに保存
set viminfo+=n~/.vimfiles/viminfo.txt

"クリップボードにコピー
set clipboard=unnamed,autoselect

imap <C-z> <ESC>:w<CR><C-z>i

