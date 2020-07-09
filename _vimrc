" =================================================
" file  : _vimrc or init.vim
" author：h-arata
" =================================================

" vimをvi互換にしない
if &compatible
  set nocompatible
endif

" -------------------------------------------------
" システム環境設定
" -------------------------------------------------
if has('win32')
  let $PATH = '$VIM' . ';' . $PATH
  let g:python3_host_prog='C:\Python38\python.exe'
  let g:python_host_prog='C:\Python27\python.exe'
endif

" vim8でpythonを認識させる
if !has('nvim')
  set pythonthreedll=C:\Python38\python38.dll
endif

" -------------------------------------------------
" キーマップ設定
" -------------------------------------------------
let mapleader = "\<Space>"
map Q gq

" -------------------------------------------------
" vim共通設定
" -------------------------------------------------
if has('win32') || has('win64')
    set directory="c:\tmp,c:\temp"
    set backupdir="c:\tmp,c:\temp"
endif

set viminfo='20,\"50
set nobackup
set autowrite
set nowritebackup
set autoindent
set smartindent
set showmatch
set matchtime=3
set warn
set showcmd
set ruler
set ttyfast
set nowrap
set wrapscan
set wildmenu
set title
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
set ts=4 sw=4 sts=4
set smarttab
set noexpandtab
set backspace=2
set scrolloff=2
set cmdheight=1
set laststatus=2
set updatecount=0
set ignorecase
set smartcase
set mouse=a
set nomousefocus
set mousehide
set suffixes+=.orig,.rej,.class,.exe,.bin
set norestorescreen
set noerrorbells
set wildmode=longest,list
set virtualedit=block
set formatoptions+=mq
set number
set selectmode=key        " キーワードが開始されたとき、Selectモードを開始するかを決定する
set t_ti= t_te=
set tw=0                  " 自動折り返ししない
set noundofile            " undofileを作成しない

" -------------------------------------------------
" grep設定
" -------------------------------------------------
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif


" -------------------------------------------------
" シェル設定
" -------------------------------------------------
set shell=powershell.exe
set shellcmdflag=-NoProfile\ -NoLogo\ -NonInteractive\ -Command
set shellxquote=
set shellquote=\"
" set shellpipe="| Tee-Object -filePath %s"
"set noshellslash

" -------------------------------------------------
" 文字コード設定
" http://www.kawaz.jp/pukiwiki/?vim#cb691f26
" -------------------------------------------------
set encoding=utf-8
scriptencoding=utf-8

if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

set makeencoding=utf-8
set termencoding=char
set fileformats=dos,unix      " 改行コードの自動認識
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" パスコピー
command! CopyPath :let @*=expand("%:p")
command! CopyDir :let @*=expand("%:h")

" -------------------------------------------------
" 個別設定
" -------------------------------------------------
if has("gui_running") || &t_Co > 2
  syntax on
  set hlsearch
endif

" 書込み前に行末の空白を除去してから保存する
" autocmd BufWritePost * silent! %s/\s\+$//g

" -------------------------------------------------
" vimファイル別設定
" -------------------------------------------------
" C言語設定
augroup cprog
  au!
  autocmd BufRead *.c,*.h,*.cc,*.cpp,*.mak,*.pc,*.mk,*.mq4,*.mqh set ts=4 sw=4 sts=4 cindent formatoptions=croql comments=sr:/*,mb:*,el:*/,://
  autocmd BufRead *.mq4,*.mqh set syntax=c
augroup END

" java設定
augroup javaprog
  au!
  autocmd BufRead *.java set ts=4 sw=4 sts=4 cindent formatoptions=croql comments=sr:/*,mb:*,el:*/,://
  autocmd BufRead *.java set dict=$VIM/dict/java.dic
  autocmd BufRead *.groovy set ts=4 sw=4 sts=4 formatoptions=croql comments=sr:/*,mb:*,el:*/,://:#
  autocmd BufRead *.scala set ts=2 sw=2 sts=2 formatoptions=croql comments=sr:/*,mb:*,el:*/,://:#
augroup END

" バイナリ設定
augroup binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" perl系
augroup perlprog
  au!
  au BufReadPre,FileReadPre,BufNewFile *.pl,*.pm,*.py,*.rb set ts=2 sw=2 sts=2 formatoptions=croql comments=:#
augroup END

" vimscript
augroup vimscript
  au!
  au BufReadPre,FileReadPre,BufNewFile *vimrc,*.vim set ts=2 sw=2 sts=2 formatoptions=croql
augroup END

" plsql設定
augroup plsql
  au!
  autocmd BufRead *.sql set syn=plsql formatoptions=croql ts=4 sw=4 sts=4
augroup END

" XML設定
augroup xmldoc
  au!
  autocmd BufRead *.html,*.htm,*.xml,*.xhtml,*.yml,*.yaml set ts=2 sw=2 sts=2
augroup END

" autocmd BufRead *.txt set tw=78
autocmd BufReadPost * if &ft=='vim' | set ts=2 sw=2 sts=2 | endif
autocmd BufReadPost * if &ft=='sh'  | set ts=2 sw=2 sts=2 | endif
autocmd BufReadPost * if &ft=='rc'  | set ts=4 sw=4 sts=4 | endif
autocmd BufRead *.ps1 set ts=4 sw=4 sts=4 formatoptions=croql comments=:# filetype=ps1


" -------------------------------------------------
" vim プラグインの設定
" -------------------------------------------------
" ファイルオープン時に対象ファイルが存在するフォルダを
" カレントディレクトリとする
" source $VIMRUNTIME/macros/cd.vim
" 2006/07/11 CdCurentで代用可能のため、特に必要ない
" Explorerから移動する際はWinManager のcで移動可能

" プログラムのコードで一つのブレース、括弧に対応するブレース、括弧やらを探し出して、
" その場所に移動する機能を強化し、HTML、XMLのタグなど複数の文字からなる記号でも、
" 対応記号へのジャンプを可能にするスクリプト(vim6標準)
source $VIMRUNTIME/macros/matchit.vim

" Windows環境のキーバインド(CTRL-V,CTRL-X ..)を使用可能にし、
" クリップボードと連携する(vim6標準)
" source $VIMRUNTIME/mswin.vim

" format.vimを利用する
" format.vimは日本語の文章(英文混じり可)を、
" ある一定の幅で自動的に折り返す機能を持っている。
let format_join_spaces = 2
let format_allow_over_tw = 0

let mygrepprg = "jvgrep"

" autocomplpop.vim で候補表示中にもEnterが効くようにする。
" http://subtech.g.hatena.ne.jp/cho45/20071111/1194766579
inoremap <expr> <CR> pumvisible() ? "\<C-Y>\<CR>" : "\<CR>"

""""""""""""""""""""""""""""""
"全角スペースを表示
""""""""""""""""""""""""""""""
"コメント以外で全角スペースを指定しているので scriptencodingと、
"このファイルのエンコードが一致するよう注意！
"全角スペースが強調表示されない場合、ここでscriptencodingを指定すると良い。
"scriptencoding cp932

"デフォルトのZenkakuSpaceを定義
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    " ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
    autocmd ColorScheme       * call ZenkakuSpace()
    " 全角スペースのハイライト指定
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

" ##################################################
" dein.vim 2018/08/15 installed
" ##################################################
"dein.vimディレクトリをruntimepathに追加する
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

"以下定型文
if dein#load_state("~/.cache/dein")
  call dein#begin("~/.cache/dein")
  call dein#add("~/.cache/dein/repos/github.com/Shougo/dein.vim")

  "好きなプラグインを dein#add() 追加していく
  "call dein#add('好きなプラグイン')
  call dein#add('vim-airline/vim-airline')

  if has('python3')
    call dein#add('Shougo/denite.nvim')
    call dein#add('Shougo/neomru.vim')
    call dein#add('Shougo/defx.nvim')
"   call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif
  endif

"  call dein#add('Shougo/neosnippet')
"  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('dracula/vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('bronson/vim-trailing-whitespace')
  call dein#add('kien/ctrlp.vim')
  call dein#add('jremmen/vim-ripgrep')
  call dein#add('haya14busa/vim-migemo')
  call dein#add('junegunn/fzf.vim')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('terryma/vim-expand-region')
  call dein#add('easymotion/vim-easymotion')
  call dein#add('simeji/winresizer')
  call dein#add('cohama/lexima.vim')
  call dein#add('tpope/vim-surround')
  call dein#add('scrooloose/nerdcommenter')
  call dein#add('kana/vim-textobj-user')
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-operator-replace')
  call dein#add('alvan/vim-closetag')

	call dein#add('SirVer/ultisnips')
	call dein#add('honza/vim-snippets')
	call dein#add('neoclide/coc.nvim', {'merged':0, 'rev':'release'})

  " 削除する場合
  " 対象のdein#addをコメントアウトして以下のコマンドを実行する
  " :call map(dein#check_clean(), "delete(v:val, 'rf')")
  " :call dein#recache_runtimepath()

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

if dein#tap('vim-closetag')
  let g:closetag_filenames = '*.htm,*.html,*.xhtml,*.phtml,*.erb,*.php,*.vue'
endif

" vim-trailing-whitespaceでハイライトを除外するファイルタイプを指定
if dein#tap('vim-trailing-whitespace')
  let g:extra_whitespace_ignore_filetypes = ['unite']
endif

" deopleteを有効にする
if dein#tap('deoplete.nvim')
  let g:deoplete#enable_at_startup=1
endif

" fzf
if dein#tap('fzf.vim')
  command! -bang -nargs=* Rgs
    \ call fzf#vim#grep(
    \   'rg --encoding Shift_JIS --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

  nnoremap <silent> <Leader>ff :<C-u>Rg<CR>
  nnoremap <silent> <Leader>fs :<C-u>Rgs<CR>
endif

" vim-expand-regionでC-vで選択範囲を拡張していく
if dein#tap('vim-expand-region')
  vmap v <Plug>(expand_region_expand)
  vmap <C-v> <Plug>(expand_region_shrink)
endif

if dein#tap('vim-easymotion')
	let g:EasyMotion_use_migemo = 1
  map  <Leader>j <Plug>(easymotion-bd-w)
  nmap <Leader>j <Plug>(easymotion-overwin-w)
  map  <Leader>l <Plug>(easymotion-bd-jk)
  nmap <Leader>l <Plug>(easymotion-overwin-line)
  map  <Leader>k <Plug>(easymotion-bd-f)
  nmap <Leader>k <Plug>(easymotion-overwin-f)
endif

" dein 設定
if dein#tap('denite.nvim')
  augroup denite_filter
    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
      nnoremap <silent><buffer><expr> <CR>
      \ denite#do_map('do_action')
      nnoremap <silent><buffer><expr> d
      \ denite#do_map('do_action', 'delete')
      nnoremap <silent><buffer><expr> p
      \ denite#do_map('do_action', 'preview')
      nnoremap <silent><buffer><expr> q
      \ denite#do_map('quit')
      nnoremap <silent><buffer><expr> i
      \ denite#do_map('open_filter_buffer')
      nnoremap <silent><buffer><expr> <Space>
      \ denite#do_map('toggle_select').'j'
    endfunction
  augroup END

  let s:denite_win_width_percent = 0.85
  let s:denite_win_height_percent = 0.7

  " Add custom menus
  let s:menus = {}
  let s:menus.file = {'description': 'File search (buffer, file, file_rec, file_mru'}
  let s:menus.line = {'description': 'Line search (change, grep, line, tag'}
  let s:menus.others = {'description': 'Others (command, command_history, help)'}
  let s:menus.file.command_candidates = [
        \ ['buffer', 'Denite buffer'],
        \ ['file: Files in the current directory', 'Denite file'],
        \ ['file_rec: Files, recursive list under the current directory', 'Denite file_rec'],
        \ ['file_mru: Most recently used files', 'Denite file_mru']
        \ ]
  let s:menus.line.command_candidates = [
        \ ['change', 'Denite change'],
        \ ['grep :grep', 'Denite grep'],
        \ ['line', 'Denite line'],
        \ ['tag', 'Denite tag']
        \ ]
  let s:menus.others.command_candidates = [
        \ ['command', 'Denite command'],
        \ ['command_history', 'Denite command_history'],
        \ ['help', 'Denite help']
        \ ]

  call denite#custom#var('menu', 'menus', s:menus)

  nnoremap [denite] <Nop>
  nmap <Leader>u [denite]
  nnoremap <silent> [denite]b :Denite buffer<CR>
  nnoremap <silent> [denite]c :Denite changes<CR>
  nnoremap <silent> [denite]f :Denite file<CR>
  nnoremap <silent> [denite]g :Denite grep<CR>
  nnoremap <silent> [denite]h :Denite help<CR>
  nnoremap <silent> [denite]l :Denite line<CR>
  nnoremap <silent> [denite]t :Denite tag<CR>
  nnoremap <silent> [denite]m :Denite file_mru<CR>
  nnoremap <silent> [denite]u :Denite menu<CR>

  call denite#custom#map(
        \ 'insert',
        \ '<Down>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<Up>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-N>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-P>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-G>',
        \ '<denite:assign_next_txt>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-T>',
        \ '<denite:assign_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '/',
        \ '<denite:enter_mode:insert>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<Esc>',
        \ '<denite:enter_mode:normal>',
        \ 'noremap'
        \)
endif

if dein#tap('defx.nvim')
  autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> c
    \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
    \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
    \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
    \ defx#do_action('open')
    nnoremap <silent><buffer><expr> E
    \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
    \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> o
    \ defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> K
    \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
    \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
    \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> C
    \ defx#do_action('toggle_columns',
    \                'mark:indent:icon:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
    \ defx#do_action('toggle_sort', 'time')
    nnoremap <silent><buffer><expr> d
    \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
    \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> !
    \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x
    \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
    \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
    \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> ;
    \ defx#do_action('repeat')
    nnoremap <silent><buffer><expr> h
    \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
    \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
    \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
    \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
    \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
    \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
    \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
    \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
    \ defx#do_action('print')
    nnoremap <silent><buffer><expr> cd
    \ defx#do_action('change_vim_cwd')
  endfunction
endif


" coc.nvim 設定
"
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" vim polyglot で csvを無効化する
let g:polyglot_disabled = ['csv']
