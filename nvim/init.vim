" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

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
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'jceb/vim-orgmode'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'sheerun/vim-wombat-scheme'
NeoBundle 'Valloric/YouCompleteMe', { 'do': './install --clang-completer' }
NeoBundle 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'peterhoeg/vim-qml'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'jiangmiao/auto-pairs'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

syntax on
set number
let mapleader = ","
let g:deoplete#enable_at_startup = 1
set shiftwidth=4

" theme
set t_Co=256
colorscheme wombat

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" NerdTree
nmap <leader>t :NERDTreeToggle<cr>

" Clipboard
set clipboard=unnamedplus

" Neovim-qt Guifont command, to change the font
command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>")
" Set font on start
let g:Guifont="DejaVu Sans Mono for Powerline:h11"

" FuzzyFinder
nmap <silent> <C-n> :Buffers<CR>
nmap <silent> <C-p> :Files<CR>

" Tag list
nmap <F8> :TagbarToggle<CR>

" You complete me
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_add_preview_to_completeopt=0
let g:ycm_warning_symbol='**'
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_auto_trigger = 1
nmap <silent> <C-j> :YcmCompleter GoTo<CR>
nmap <silent> <C-]> :Tags<CR>

" Configure buffers
" This allows buffers to be hidden.
set hidden

" To open a new empty buffer
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
nmap <leader>bq :bp <BAR> bd #<CR>

" Remap Alt+[hjkl] to jump between windows
if has('nvim')
  :tnoremap <A-h> <C-\><C-n><C-w>h
  :tnoremap <A-j> <C-\><C-n><C-w>j
  :tnoremap <A-k> <C-\><C-n><C-w>k
  :tnoremap <A-l> <C-\><C-n><C-w>l
endif
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
:tnoremap <Esc> <C-\><C-n>


"auto pairs
"execute "set <M-p>=\ep"
"nnoremap <M-p> p
"execute "set <M-e>=\ee"
"nnoremap <M-e> e
"execute "set <M-n>=\en"
"nnoremap <M-n> n
"execute "set <M-b>=\eb"
"nnoremap <M-b> b
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutToggle='<M-p>'
let g:AutoPairsShortcutFastWrap='<M-e>'
let g:AutoPairsShortcutJump='<M-n>'
let g:AutoPairsShortcutBackInsert='<M-b>'

"complile by key

autocmd BufRead,BufNewFile *.pas nnoremap <F4> :!clear; fpc % <enter>
autocmd BufRead,BufNewFile *.pas nnoremap <F5> :!clear; ./%< <enter>
autocmd BufRead,BufNewFile *.pas nnoremap <C-F5> :!./%<

autocmd BufRead,BufNewFile *.cpp nnoremap <F4> :!clear; g++ -o %< % <enter>
autocmd BufRead,BufNewFile *.cpp nnoremap <F5> :!clear; g++ -o %< % && ./%< <enter>
autocmd BufRead,BufNewFile *.cpp nnoremap <C-F5> :!./%<

autocmd BufRead,BufNewFile *.cc nnoremap <F4> :!clear; g++ -o %< % <enter>
autocmd BufRead,BufNewFile *.cc nnoremap <F5> :!clear; g++ -o %< % && ./%< <enter>
autocmd BufRead,BufNewFile *.cc nnoremap <C-F5> :!./%<

autocmd BufRead,BufNewFile *.c nnoremap <F4> :!clear; gcc -o %< % <enter>
autocmd BufRead,BufNewFile *.c nnoremap <F5> :!clear; gcc -o %< % && ./%< <enter>
autocmd BufRead,BufNewFile *.c nnoremap <C-F5> :!./%<

autocmd FileType cpp set keywordprg=cppman
autocmd FileType h set keywordprg=cppman
autocmd FileType c set keywordprg=cppman

autocmd BufRead,BufNewFile *.go nnoremap <F5> :!clear; go run % <enter>
autocmd BufRead,BufNewFile *.go nnoremap <C-F5> :!clear; go run %
autocmd BufRead,BufNewFile *.go nnoremap <F4> :GoTest % <enter>

autocmd BufRead,BufNewFile *.pl nnoremap <F5> :!clear; perl % <enter>
autocmd BufRead,BufNewFile *.pl nnoremap <C-F5> :!clear; perl %
