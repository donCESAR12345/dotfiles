" Tabs. Copied and modified 
set tabstop=2
set softtabstop=0
set shiftwidth=2
set expandtab

" No highlight. After finding what I was searching for
map <esc> :noh <CR>

" No linewrap. Keeps the line numbering aesthetic
set nowrap

" Airline powerline fonts enable
let g:airline_powerline_fonts = 1

" Asyncomplete TAB completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

