""""""""""""""""""""""""""""""
" Loading defaults.vim
""""""""""""""""""""""""""""""
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Setup plugins
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Listing the files in a directory.
Plug 'scrooloose/nerdtree'
" Automatically inserting the end keyword in Ruby.
Plug 'tpope/vim-endwise'
" Easily toggle comments ON/OFF.
Plug 'tomtom/tcomment_vim'

" Coloring indentation for better readability.
Plug 'nathanaelkane/vim-indent-guides'
" Automatically enabling vim-indent-guides when Vim starts.
let g:indent_guides_enable_on_vim_startup=1
" Specify the amount of indentation to start the guide.
let g:indent_guides_start_level=2
" Specify the width of the guide.
let g:indent_guides_guide_size=1
" Specify the color of the guide.
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=red ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

call plug#end()
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Setting various options
""""""""""""""""""""""""""""""
" Replace tab input with multiple spaces.
set expandtab
" Visualize tabs, spaces, and newlines.
set list
set listchars=tab:»-,trail:_,extends:»,precedes:«,nbsp:%
" Display line numbers.
set number
" Change the display width of tab characters.
set tabstop=2
" Change the width of the indentation inserted by Vim.
set shiftwidth=2
" Specify the color scheme.
colorscheme desert
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Change the cursor shape based on the mode
" For reference, see: https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
"                     https://qiita.com/usamik26/items/f733add9ca910f6c5784
""""""""""""""""""""""""""""""
if has('vim_starting')
  " A blinking block-type cursor in normal mode.
  let &t_EI.="\e[1 q"
  " A blinking vertical bar-type cursor in insert mode.
  let &t_SI.="\e[5 q"
  " A blinking underline-type cursor in replace mode.
  let &t_SR.="\e[3 q"
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Display full-width spaces
" For reference, see: https://qiita.com/jnchito/items/5141b3b01bced9f7f48f
"                     https://inari111.hatenablog.com/entry/2014/05/05/231307
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace','　')
  augroup END
  call ZenkakuSpace()
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" Change the status line color in insert mode
" For reference, see: https://qiita.com/jnchito/items/5141b3b01bced9f7f48f
"                     https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-color#color-insertmode
""""""""""""""""""""""""""""""
let g:hi_insert='highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd=''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd='highlight '.s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
    exec 'highlight '.a:hi
  redir END
  let hl=substitute(hl,'[\r\n]','','g')
  let hl=substitute(hl,'xxx','','')
  return hl
endfunction
""""""""""""""""""""""""""""""
