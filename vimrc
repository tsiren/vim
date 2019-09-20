syntax on
filetype plugin indent on

" GENERIC
"set tags=~/mytags
packadd! dracula-theme
colo dracula 
set number
set hlsearch
" Enable jumplist when file has been changed
set hidden
let mapleader=","
" Enable mouse
set mouse=a

" replace tabs with spaces
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" hightlight current line
set cursorline

" more powerful backspacing
set backspace=indent,eol,start

" specific file types
autocmd Filetype yaml setlocal shiftwidth=2 tabstop=2
autocmd Filetype yml setlocal shiftwidth=2 tabstop=2
autocmd Filetype go setlocal noexpandtab

" set auto-indenting on for programming
set ai

" turn off compatibility with the old vi
set nocompatible

" turn on the "visual bell" - which is much quieter than the "audio blink"
set vb

" automatically show matching brackets. works like it does in bbedit.
set showmatch

set tags=./tags,tags

:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a
" Allow us to use Ctrl-s and Ctrl-q as keybinds
silent !stty -ixon
" Restore default behaviour when leaving Vim.
autocmd VimLeave * silent !stty ixon

" Synchronize unnamed register with clipboard
set clipboard^=unnamed,unnamedplus

" NERDTREE
autocmd vimenter * NERDTree
" Move cursor to window 2 when opening
autocmd VimEnter * exe 2 . "wincmd w"
" autoclose nerdtree if only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <F9> :NERDTreeFind<CR>
map <F12> :NERDTreeToggle<CR>

" CTRL-P plugin
set runtimepath^=~/.vim/pack/my-plugins/start/ctrlp.vim

let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|node_modules)$'
let g:ctrlp_show_hidden = 1
" Use ag as ctrlp backend, which is faster and allows to use .agignore files
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

let g:detect_mod_reg_state = -1
function! DetectRegChangeAndUpdateMark()
    let current_small_register = getreg('"-')
    let current_mod_register = getreg('""')
    if g:detect_mod_reg_state != current_small_register ||
                \ g:detect_mod_reg_state != current_mod_register
        normal! mM
        let g:detect_mod_reg_state = current_small_register
    endif
endfunction

" Mark I at the position where the last Insert mode occured across the buffer
autocmd InsertLeave * execute 'normal! mI'

" Mark M at the position when any modification happened in the Normal or Insert mode
autocmd CursorMoved * call DetectRegChangeAndUpdateMark()
autocmd InsertLeave * execute 'normal! mM'

" close quick-fix & location list
nnoremap <silent> <leader>c :cclose<CR>:lclose<CR>:pc<CR>
" noremap <Leader>c :ccl <bar> lcl<CR>

" vim-go 
"
" Automatically get signature/type info for object under cursor
let g:go_auto_type_info = 1
let g:go_doc_popup_window = 1

let g:go_addtags_transform = "camelcase"
"
" Fix vim-go GoCallers to search subpackages
"function! s:go_guru_scope_from_git_root()
"  let gitroot = system("git rev-parse --show-toplevel | tr -d '\n'")
"  let pattern = escape(go#util#gopath() . "/src/", '\ /')
"  return substitute(gitroot, pattern, "", "") . "/... -vendor/"
"endfunction
"
"au FileType go silent exe "GoGuruScope " . s:go_guru_scope_from_git_root()
"
"
" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Common Go commands
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
"au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>r <Plug>(go-referrers)
au FileType go nmap <leader>k <Plug>(go-coverage-toggle)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go nmap <Leader>a <Plug>(go-alternate-edit)
