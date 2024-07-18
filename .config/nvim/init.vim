""" Plugin manager
call plug#begin(stdpath('data') . '/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-surround'
    Plug 'easymotion/vim-easymotion'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
    Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
call plug#end()

""" theme
set termguicolors
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_number_column='bg0'
colorscheme gruvbox

""" setting
set number relativenumber  " relative number line
set clipboard+=unnamedplus  " global clipboard
set nowrap  " no line wrapping
set ignorecase  " ignore case in search
set smartcase  " override ignorecase  if the search pattern contains uppercase
set nohlsearch  " no highlight search results
set mouse=a  " enable mouse
set ruler  " show ruler
set rulerformat=%80(%1*%.3n\ %f\%=%l,%(%c%V%)\ %P%)%*  " set ruler format
set timeoutlen=1000 ttimeoutlen=0  " Key, keycode delay
set tabstop=8 softtabstop=0 expandtab shiftwidth=4  " indentation
set cursorline  " highlight line with cursor"
set showtabline=0  " hide actual tabline
set laststatus=0  " never show status line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " disable auto comment

""" remapping
" space as leader
let mapleader = " "

" remap j, k
map J <C-d>zz
map K <C-u>zz
"vnoremap J :m '>+1<CR>gv=gv
"vnoremap K :m '<-2<CR>gv=gv

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" map :W to sudo write
command W w !sudo tee %

" map Y to have same behavior as C and D
map Y y$

" map Enter to new line
nmap <cr> o<esc>

" disable Ex mode
map Q <Nop>

""" nerdtree
" toggle
map <C-n> :NERDTreeToggle<CR>
map <Leader>n :NERDTreeToggle<CR>

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" bookmark file
let NERDTreeBookmarksFile = '~/.local/share/nvim' . '/NERDTreeBookmarks'

""" easymotion 
map <Leader> <Plug>(easymotion-prefix)

""" CoC
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" goto code navigations
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gr <Plug>(coc-references)

" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf <Plug>(coc-fix-current)

" Show all diagnostics
nnoremap <silent><nowait> <leader>a :<C-u>CocList diagnostics<cr>

" Use K to show documentation in preview window
nnoremap <leader>K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Code format
nmap <F7> :call CocAction('format')<CR>

""" fzf
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <C-o> :Files<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>s :Rg<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <Leader>v :vsplit<CR>:Files<CR>

"""treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = { "cpp" },
    additional_vim_regex_highlighting = false,
  },
}
EOF

""" buffer
nnoremap <leader>j :bnext<CR>
nnoremap <leader>k :bprevious<CR>
nnoremap <leader><tab> <C-^>

" bufferline
lua << EOF
require("bufferline").setup{
  options = {
    numbers = function(opts)
      return string.format('%s', opts.raise(opts.id))
    end,
    middle_mouse_command = "bdelete! %d",
    offsets = { { filetype = "nerdtree", text = "NERDTree" } },
  },
  highlights = {
    fill = {
      bg = '#282828',
    },
  },
}
EOF
nnoremap <Leader>` :BufferLinePick<CR>
nnoremap <Leader>d :bd<CR>
