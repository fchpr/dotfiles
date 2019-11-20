set number
" F9 -> Toggle line wrap
map <F9> :set wrap!<cr>
" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When on uses space instead of tabs
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

" Make sure you use single quotes
call plug#begin()

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Fuzzy finding
Plug 'vim-scripts/ag.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Autocompletion, syntax highlight
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" :CocInstall coc-css
" :CocInstall coc-svelte
Plug 'evanleck/vim-svelte'
Plug 'terryma/vim-multiple-cursors'

" Themes
Plug 'dikiaap/minimalist'
"Plug 'danilo-augusto/vim-afterglow'
"Plug 'sainnhe/edge'
"Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'

call plug#end()

nmap <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=25
let NERDTreeShowHidden=1

" Fuzzy finder 
let g:fzf_commands_expect = 'alt-enter'
let g:fzf_history_dir = '~/.local/share/fzf-history'
map ` :Files<CR>
" Buffers navegation
map <Tab> :bnext<cr>
map <S-Tab> :bprev<cr>
map <A-Tab> :Buffers<cr>

" Themes
set t_Co=256
syntax on
colorscheme minimalist
"hi Normal guibg=NONE ctermbg=NONE
"colorscheme afterglow
"let g:airline_theme='afterglow'
"set termguicolors
"set background=dark
"colorscheme edge

let g:airline_theme='murmur'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'
"let g:airline#extensions#tabline#formatter = 'default'
"let g:airline_statusline_ontop=1

" Hide bottom status line
"set noshowmode
"set noruler
"set laststatus=0
"set noshowcmd
"set cmdheight=1

let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
" Shift + H -> Hide status line
nnoremap <S-h> :call ToggleHiddenAll()<CR>

