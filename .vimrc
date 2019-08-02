""""""""""""""""""""""""""""""
" defaults.vimの読込
""""""""""""""""""""""""""""""
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" プラグインのセットアップ
""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" ディレクトリのファイル一覧を表示する
Plug 'scrooloose/nerdtree'
" Rubyのendキーワードを自動挿入する
Plug 'tpope/vim-endwise'
" コメントON/OFFを手軽に実行する
Plug 'tomtom/tcomment_vim'

" インデントに色を付けて見易くする
Plug 'nathanaelkane/vim-indent-guides'
" Vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup=1
" ガイドをスタートするインデントの量を指定する
let g:indent_guides_start_level=2
" ガイドの幅を指定する
let g:indent_guides_guide_size=1
" ガイドの色を指定する
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=red ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

call plug#end()
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 各種オプションの設定
""""""""""""""""""""""""""""""
" タブ入力を複数の空白入力に置き換える
set expandtab
" タブ、空白、改行を可視化する
set list
set listchars=tab:»-,trail:_,extends:»,precedes:«,nbsp:%
" 行番号を表示する
set number
" タブ文字の表示幅を変更する
set tabstop=2
" Vimが挿入するインデントの幅を変更する
set shiftwidth=2
" カラースキーマを指定する
colorscheme desert
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" モードによってカーソル形状変更
" https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
" https://qiita.com/usamik26/items/f733add9ca910f6c5784
""""""""""""""""""""""""""""""
if has('vim_starting')
  " ノーマルモード時に点滅のブロックタイプのカーソル
  let &t_EI.="\e[1 q"
  " 挿入モード時に点滅の縦棒タイプのカーソル
  let &t_SI.="\e[5 q"
  " 置換モード時に点滅の下線タイプのカーソル
  let &t_SR.="\e[3 q"
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 全角スペースの表示
" https://qiita.com/jnchito/items/5141b3b01bced9f7f48f
" https://inari111.hatenablog.com/entry/2014/05/05/231307
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
" 挿入モード時、ステータスラインの色を変更
" https://qiita.com/jnchito/items/5141b3b01bced9f7f48f
" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-color#color-insertmode
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
