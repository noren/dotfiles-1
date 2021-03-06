" Bootstrap {{{

" Turn off vi compatibility. If I wanted vi, I would use vi.
set nocompatible

" Reset all autocmds
autocmd!

" Load matchit library. This lets % match if/elsif/else/end, open/close
" XML tags, stuff like that, instead of just brackets and parens.
runtime macros/matchit.vim

" Detect the OS
if has('unix')
    let s:uname = system('uname')
    if s:uname == "Darwin\n"
        let s:has_darwin = 1
    endif
endif

" ------------------------------------------------------------------------ }}}
" Pathogen {{{

" vim-pathogen, for sane plugin management.
" https://github.com/tpope/vim-pathogen

let g:pathogen_disabled = []

filetype off
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" ------------------------------------------------------------------------ }}}
" General settings {{{

let mapleader = ','
let maplocalleader = '\'

" Turn on mouse support
set mouse=a

" Allow 'hidden' buffers. :help hidden
set hidden

" Ignore whitespace-only changes in diff mode
set diffopt=iwhite

" Which VCS Signify should care about
"let g:signify_vcs_list = [ 'git', 'svn' ]

" Prefer postgres SQL
let g:sql_type_default = 'pgsql'

" ------------------------------------------------------------------------ }}}
" General keymaps {{{

" Use jj to get back to command mode instead of Esc, which is out of the
" way and on some keyboards hard to reach. Esc still works too.
"inoremap jj <esc>
" map this too to be uniform with oh-my-zsh
"inoremap jk <esc>

" Going to try to standardize on kj because Apple is taking away my Esc key
" I AM NOT ANGRY, REALLY, NO SERIOUSLY WHY WOULD THAT MAKE ME ANGRY?
"inoremap kj <esc>
"inoremap <esc> <nop>

" Use more natural key movement on wrapped lines.
nnoremap j gj
nnoremap k gk

" But give me a way to do the default behavior when I want it
nnoremap gj j
nnoremap gk k

" Open quickfix window
nnoremap <leader>q :cwindow<cr>
" Open location list window
nnoremap <leader>l :lwindow<cr>

" Source the current line
nnoremap <leader>S ^vg_y:execute @@<cr>
vnoremap <leader>S y:execute @@<cr>

" Redraw the screen
nnoremap <leader>L :syntax sync fromstart<cr>:redraw!<cr>

" Define 'del' char to be the same backspace (saves a LOT of trouble!)
" As the angle notation cannot be use with the LeftHandSide
" with mappings you must type this in *literally*!
" map <c-v>127 <c-h>
" cmap <c-v>127 <c-h>
inoremap  <c-h>
cnoremap  <c-h>
" the same for Linux Debian which uses
inoremap <esc>[3~ <c-h>
cnoremap <esc>[3~ <c-h>

" go to location of last change
nnoremap gl `.

nnoremap <leader>f :NERDTreeToggle<cr>

" ------------------------------------------------------------------------ }}}
" Messages and alerts {{{

set noerrorbells
set visualbell

" Kind of messages to show. Abbreviate them all.
set shortmess=atI

" Show a report when N lines were changed. report=0 means 'show all changes'.
set report=0

if !has('gui_running')
    " Terminal's visual bell - turned off to make Vim quiet.
    set t_vb=
endif

" ------------------------------------------------------------------------ }}}
" Status and title bars {{{

" Always show the status bar
set laststatus=2

" Show the current mode (INSERT, REPLACE, VISUAL, paste, etc.)
set showmode

" Show current uncompleted command.
set showcmd

" Set the title bar if running as GUI, but never in terminals. If set in
" a terminal, it will wipe away my title and not reset it on exit.
" Disable the toolbar in GUI mode
if has('gui_running')
    set title
    set guioptions=-t
else
    set notitle
endif

" Activate Fugitive in statline
let g:statline_fugitive = 1

" ------------------------------------------------------------------------ }}}
" Cursor and position indicators {{{

" Show current cursor line position
set cursorline

" Show row/col of cursor position, and percentage into the file we are.
set ruler

set number
if v:version >= 704
    set relativenumber
    nnoremap <silent> <leader>n :set number! number?<cr>:set relativenumber! relativenumber?<cr>
else
    nnoremap <silent> <leader>n :set number! number?<cr>
endif

" Restore cursor position from our last session, if known.
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal! g`"zvzz' | endif

" Only show the 'margin' column in insert mode
if exists('&colorcolumn')
    autocmd InsertEnter * set colorcolumn=80
    autocmd InsertLeave * set colorcolumn=""
endif

" ------------------------------------------------------------------------ }}}
" Tabs and indenting {{{

set expandtab

set tabstop=8
set softtabstop=4

" Number of columns to use for (auto)indent. Generally this should be the
" same as the tabstop.
set shiftwidth=4

" When changing indent with <, >, >>, <<, use a multiple of shiftwidth.
set shiftround

" Keep selection when indent/dedenting in select mode.
vnoremap > >gv
vnoremap < <gv

" ------------------------------------------------------------------------ }}}
" Selecting {{{

" Reselect what was just pasted so I can so something with it.
" (To reslect last selection even if it is not the last paste, use gv.)
nnoremap <leader>v `[v`]

" Select current line, excluding leading and trailing whitespace
nnoremap vv ^vg_

" ------------------------------------------------------------------------ }}}
" Copy and paste {{{

" Key combo to toggle paste-mode
set pastetoggle=,p

" Duplicate current selection (best used for lines, but can be used
" with any selection). Pastes duplicate at end of select region.
vnoremap D y`>p

" ------------------------------------------------------------------------ }}}
" Formatting {{{

" Text formatting options, used by 'gq', 'gw' and elsewhere. :help fo-table
set formatoptions=qrn1

" Insert two spaces after a period with every joining of lines? No!
set nojoinspaces

" Reformat current paragraph, selection, or line.
nnoremap Q gqip
vnoremap Q gq
nnoremap ql ^vg_gq

" Strip trailing whitespace file-wide, preserving cursor location
nnoremap <leader>W :call Preserve('%s/\s\+$//e')<cr>

" Swap ' for " (or vice versa) on strings, preserving cursor location
nnoremap <silent> <leader>' :call Preserve("normal cs\"'")<cr>
nnoremap <silent> <leader>" :call Preserve("normal cs'\"")<cr>

" Remap ~ to cycle through uppercase, lowercase, title-case.
vnoremap ~ ygv"=TwiddleCase(@")<cr>Pgv

" ------------------------------------------------------------------------ }}}
" Wrapping {{{

" I use Vim mostly to write code. This doesn't auto-wrap lines, it only does
" a soft wrap to the window width.
set wrap

" No fixed width; 0 means to use the current window width, max out at 79.
set textwidth=0

" Break lines at whitespace or special characters (when tw != 0). Avoids lines
" where a word shows up on both the right and left edges of the screen. Which
" makes copy/paste into other apps FUN. Screws up coding. Off normally. makes
" copy/paste into other apps FUN. Screws up coding. Off normally.
set nolinebreak

" Backspace over indentation, end-of-line, and start-of-line.
set backspace=indent,eol,start

" ------------------------------------------------------------------------ }}}
" Folding {{{

" Use explicit markers for folding (triple curly-brace)
set foldmethod=marker

" Use space to toggle folds.
nnoremap <space> za

" Focus on the current fold
nnoremap <leader>z zMzvzz

" Fold current HTML tag.
nnoremap <leader>Ft Vatzf

" ------------------------------------------------------------------------ }}}
" History, undo and caches {{{

" What to store from an editing session in the viminfo file.
" Can be used at next session.
set viminfo=%,'50,\"100,:100,n~/.viminfo

" Increase the history size (default is 20).
set history=100

" Some cache / backup locations
"set backupdir=~/.vim/tmp/backup// " backups
"set directory=~/.vim/tmp/swap//   " swap files
"set backup                        " enable backups

" set noswapfile                    " It's 2012, Vim.
"if has('persistent_undo')
"    set undodir=~/.vim/tmp/undo//   " undo files
"endif

" ------------------------------------------------------------------------ }}}
" Search and replace {{{

" Highlight matches, and use incremental search (like iTunes).
set hlsearch
set incsearch

" Ignore case in search patterns unless an uppercase character is used
" in the search, then pay attention to case.
set ignorecase
set smartcase

" Clear the highlighted words from an hlsearch (can be visual clutter).
nnoremap <silent> <leader><space> :nohlsearch<cr>:call clearmatches()<cr>

" Turn hlsearch on or off.
nnoremap <leader>h :set hlsearch!<cr>

" Turn off vim's default regex and use normal regexes (behaves more
" like Perl regex now...) - this is 'very magic' mode. Only alphanumerics
" and underscore are *not* quoted with backslash. See ':help magic'.
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
" But if I want no magic (default regex), just tap the search character twice
nnoremap // /
vnoremap // /
nnoremap ?? ?
vnoremap ?? ?

" Use 'magic' patterns (extended regex) in search patterns. ('\s\+').
" This isn't used by the / search due to the / remaps. For :s and :g.
set magic

" Assume /g at the end of any :s command. I usually want that anyway.
set gdefault

" Since we borrowed , for the mapleader, replicate its purpose in \
" (the mapleader we displaced).
nnoremap \ ,

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" ------------------------------------------------------------------------ }}}
" Invisibles {{{

" Do not show invisibles by default.
set nolist

" Turn invisibles on/off.
nnoremap <silent> <leader>i :set list!<cr>

" How to display tabs, EOL, and other invisibles.
if has('multi_byte')
    set encoding=utf-8
    set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
else
    set listchars=tab:>-,eol:$,extends:>,precedes:<
endif

" ------------------------------------------------------------------------ }}}
" Expansion and completion {{{

" Keystroke used for 'expansion' on the command line. Default is <c-e>.
set wildchar=<tab>

" Show me more than the first possible completion.
set wildmenu

" Behave like a shell, show me completion only to point of ambiguity.
set wildmode=list:longest

" Toggle English-word completion from system dictionary. (^n, ^p)
nnoremap <silent> <leader>E :call ToggleFlag('complete', 'k', 'English completion')<cr>

" ------------------------------------------------------------------------ }}}
" Text object 'N': number {{{

onoremap N :<c-u>call <sid>NumberTextObject(0)<cr>
xnoremap N :<c-u>call <sid>NumberTextObject(0)<cr>
onoremap aN :<c-u>call <sid>NumberTextObject(1)<cr>
xnoremap aN :<c-u>call <sid>NumberTextObject(1)<cr>
onoremap iN :<c-u>call <sid>NumberTextObject(1)<cr>
xnoremap iN :<c-u>call <sid>NumberTextObject(1)<cr>

function! s:NumberTextObject(whole)
    normal! v

    while getline('.')[col('.')] =~# '\v[0-9]'
        normal! l
    endwhile

    if a:whole
        normal! o

        while col('.') > 1 && getline('.')[col('.') - 2] =~# '\v[0-9]'
            normal! h
        endwhile
    endif
endfunction

" ------------------------------------------------------------------------ }}}
" Spelling {{{

" System dictionary to use
set dictionary=/usr/share/dict/words

" Spellcheck language
set spelllang=en_us

" Toggle spellcheck mode
nnoremap <leader>s :set spell!<cr>

" ------------------------------------------------------------------------ }}}
" Windows and tabpages {{{

" Create new windows below/at right of current one, if no direction was specified.
set splitbelow
set splitright

" Create a new vertical window to the right, and switch to it.
nnoremap <silent> <leader>w :wincmd v<cr>:wincmd l<cr>

" Easier window nav keys (ctrl-<direction>)
" Look in plugin/tmux_navigator.vim now
"nnoremap <silent> <c-h> :wincmd h<cr>
"nnoremap <silent> <c-j> :wincmd j<cr>
"nnoremap <silent> <c-k> :wincmd k<cr>
"nnoremap <silent> <c-l> :wincmd l<cr>

" Use default split window height (0 disables special help height).
set helpheight=0

" Open a new tab in the current view.
nnoremap <silent> <leader>t :tabnew<cr>

" Tab navigation
nnoremap <c-t> :tabnext<cr>

" Resize splits when the window is resized.
autocmd VimResized * :wincmd =

" ------------------------------------------------------------------------ }}}
" GUI window size {{{

if has('gui_running')
    set lines=40
    set columns=90
endif

" ------------------------------------------------------------------------ }}}
" Finding and opening files {{{

" List of directories to search when I specify a file with an edit command.
set path=.

" cd to the directory of the current file. Makes it easier to :e
" files in the same directory... but it breaks gitv.
" autocmd BufEnter * cd %:p:h

" Ignore filename with any of these suffixes when using the
" ":edit" command. Most of these are files created by LaTeX.
set suffixes=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.tgz,.sit,.dmg,.hqx

" Open filename under cursor (optionally in new tab or window)
nnoremap <leader>of gf
vnoremap <leader>of gf
nnoremap <leader>ow :wincmd f
vnoremap <leader>ow :wincmd f
nnoremap <leader>ot :wincmd gf
vnoremap <leader>ot :wincmd gf

" Open a file browser
nnoremap <leader>e :edit .<cr>

" ------------------------------------------------------------------------ }}}
" Shell and external commands {{{

" Shell to use. Stick with the old standard.
let &shell='/bin/sh'

" Execute the current line via the default shell, replacing the line with
" the resulting output.
nnoremap <silent> <leader>X :echo 'Executing...'<cr>:execute ':.!' . &shell<cr>

" Automatically save modifications to files when you use
" critical (external) commands.
set autowrite

" QuickRun the current buffer, autodetecting syntax
nnoremap <leader>r :QuickRun<cr>

" Read current buffer, turn it into a bookmarklet, insert that bookmarklet
" in a comment on line 1 (discarding previously inserted bookmarklet if it
" exists), copy bookmarklet to the clipboard.
nnoremap <silent> <leader>B :%!$HOME/.vim/bin/bookmarklet_build.pl<cr>

" Preview a markdown file in the default browser
if exists('s:has_darwin')
    nnoremap <leader>M :w!<cr>:!$HOME/.vim/bin/markdownify % > /tmp/%.html && open /tmp/%.html<cr><cr>
endif

" Convert file, or selection, so each contiguous non-whitespace blob is
" on its own line. Strip all other whitespace.
nnoremap <leader>O :%!$HOME/bin/convert-to-one-string-per-line.rb<cr>
vnoremap <leader>O :!$HOME/bin/convert-to-one-string-per-line.rb<cr>

" ------------------------------------------------------------------------ }}}
" Fonts and colors {{{

if has('gui_running')
    set guifont=Mensch:h14
    set antialias
else
    set background=dark
    colorscheme cobalt2
endif

" Mark Git-style conflict markers, and trailing whitespace.
match ErrorMsg '\(\s\+$\|\(^\(<\|=\|>\)\{7\}\([^=].\+\)\?$\)\)'

" ------------------------------------------------------------------------ }}}
" Syntax {{{

" Syntax: General {{{

" 'syntax enable' will turn on syntax highlighting without wiping out
" any highlight commands already in place. 'syntax on' will reset it
" all to defaults. So I use 'syntax on' and put my highlight commands
" after this point, that way I can ':so ~/.vimrc' and reset everything
" whenever I want.
syntax on

" Another way to do things would be
"if !exists("g:syntax_on")
"    syntax enable
"endif

" When positioned on a bracket, highlight its partner.
set showmatch

" Modelines are kind of ugly, and I've read there are security problems
" with them. Disabling.
" Hah, this is funny, I was just trying to convince my team to start using
" modelines, and here I have them disabled, claiming security problems.
set nomodeline
set modelines=0

" Create an HTML version of our syntax highlighting for display or printing.
nnoremap <leader>H :TOhtml<cr>

" Ask Vim for the syntax type at cursor location
nnoremap <leader>? :call SynStack()<cr>

" ------------------------------------------------------------------------ }}}
" Syntax: BIND {{{

autocmd BufNewFile,BufRead *.com set filetype=bindzone

" ------------------------------------------------------------------------ }}}
" Syntax: Email and Exim {{{

autocmd BufNewFile,BufRead aliases.* set filetype=mailaliases
autocmd BufNewFile,BufRead exim.cf* set filetype=exim

" ------------------------------------------------------------------------ }}}
" Syntax: Epub {{{

" Look inside .epub files
au BufReadCmd *.epub call zip#Browse(expand('<amatch>'))

" ------------------------------------------------------------------------ }}}
" Syntax: help {{{

autocmd Filetype help nnoremap <buffer> <space> <PageDown>
autocmd Filetype help nnoremap <buffer>  <PageUp>

" ------------------------------------------------------------------------ }}}
" Syntax: JSON {{{

autocmd Filetype json nnoremap <leader>J <esc>:%!json_xs -f json -t json-pretty<cr>

" ------------------------------------------------------------------------ }}}
" Syntax: Make {{{

" Makefile requires real tabs, not spaces, enforce that
autocmd BufNewFile,BufRead [Mm]akefile* set filetype=make
autocmd Filetype make setlocal noexpandtab

" ------------------------------------------------------------------------ }}}
" Syntax: Markdown, MultiMarkdown, Octopress {{{

" Octopress is a superset of Markdown so just use it everywhere.
" Set line wrapping for convenience.
"autocmd BufNewFile,BufRead *.md,*.markdown set filetype=octopress
"autocmd FileType markdown,octopress setlocal tw=78 wrap lbr ts=4 sw=4 sts=4

autocmd BufNewFile,BufRead *.md,*.mmd set filetype=ghmarkdown

" Bold/italic for Markdown/Octopress (plugin 'surround')
autocmd FileType markdown,octopress let b:surround_{char2nr('i')} = "*\r*"
autocmd FileType markdown,octopress let b:surround_{char2nr('b')} = "**\r**"

" ------------------------------------------------------------------------ }}}
" Syntax: Perl {{{

autocmd BufNewFile,BufRead *.t set filetype=perl

" ------------------------------------------------------------------------ }}}
" Syntax: PHP {{{

autocmd BufNewFile,BufRead *.inc set filetype=php

" ------------------------------------------------------------------------ }}}
" Syntax: Shell {{{

autocmd BufNewFile,BufRead .bash/*,bash/* set filetype=sh

" ------------------------------------------------------------------------ }}}
" Syntax: Template Toolkit {{{

autocmd BufNewFile,BufRead *.tt2 set filetype=tt2html

" ------------------------------------------------------------------------ }}}
" Syntax: Text {{{

autocmd BufNewFile,BufRead *.txt set filetype=text

" ------------------------------------------------------------------------ }}}
" Syntax: Vim {{{

" Snippet files need real tabs, at least on the left margin.
" This works out okay because when they're triggered, if expandtab
" is set, they will be translated to spaces during expansion.
autocmd FileType snippet setlocal noexpandtab

" ------------------------------------------------------------------------ }}}
" Syntax: YAML {{{

" YAML requires spaces, not tabs
autocmd FileType yaml setlocal expandtab ts=2 sts=2 sw=2

" ------------------------------------------------------------------------ }}}

" ------------------------------------------------------------------------ }}}
" Highlight interesting words {{{
" A Steve Losh joint

" This needs to be at or near the end of .vimrc for some reason, to work.

" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n)
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let b:mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(b:mid)

    " Construct a literal pattern that has to match at boundaries.
    let b:pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, b:pat, 1, b:mid)

    " Move back to our original location.
    normal! `z
endfunction

" Mappings
nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>

" Default Highlights
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=129
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" ------------------------------------------------------------------------ }}}
" Local customizations {{{

" Override this file without modifying the master copy in git.
if filereadable($HOME . '/.vimrc.local')
    source ~/.vimrc.local
endif

" ------------------------------------------------------------------------ }}}
