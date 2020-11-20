" Install vim-plug automatically
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load vim-plug
call plug#begin()
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'                " Fuzzy find
Plug 'https://github.com/sjl/gundo.vim.git'                     " Undo Visualization
Plug 'https://github.com/Yggdroot/indentLine.git'               " Vim Indent Guide
Plug 'https://github.com/tomtom/tcomment_vim.git'               " Easy Bulk Comments
Plug 'https://github.com/itchyny/lightline.vim.git'             " Powerline Alternative
Plug 'dracula/vim', { 'as': 'dracula' }                         " Dracula colorscheme
Plug 'https://github.com/airblade/vim-gitgutter.git'            " Shows git info on left
Plug 'https://github.com/dhruvasagar/vim-table-mode.git'        " Easy tables in plain text
Plug 'jbgutierrez/vim-better-comments'                          " Colored comments
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'stephpy/vim-yaml'
Plug 'nblock/vim-dokuwiki'
Plug 'ayu-theme/ayu-vim'
call plug#end()

set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu

autocmd BufRead,BufNewFile *.txt       set filetype=dokuwiki

syntax enable           " enable syntax processing
set relativenumber      " set relative numbers
set tabstop=2           " set tab size
set softtabstop=2       " set tab size
set shiftwidth=2        " set tab size
set expandtab           " set tab size
set smarttab            " set tab size
set autoindent          " set tab size
set number              " show line numbers
set showcmd             " show command in bottom bar
set noshowmode          " hide mode as it's redundant with powerline
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max" space open/closes folds
set foldmethod=indent   " fold based on indent level
set linebreak

" keybinds ----------------------------------------------------------
let mapleader=","       " leader is comma

" comma+w is save
nnoremap <leader>w :w<CR>
" comma+q is quit
nnoremap <leader>q :q<CR>
" Use spacebar to unfold/fold
nnoremap <space> za
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" move to beginning/end of line
nnoremap B ^
nnoremap E $
" highlight last inserted text
nnoremap gV `[v`]
" jj is escape
inoremap jj <esc>
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
" save session
nnoremap <leader>s :mksession<CR>


"" Plugin Shortcuts --------------------------------------------------------

" Powerline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'


" allows cursor change in tmux mode
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
