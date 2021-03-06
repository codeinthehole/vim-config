" ============= " VIMRC file for David Winterbottom (@codeinthehole) " ===========
"
" Inspiration {{{
" -----------
" Videos:
" - http://www.youtube.com/watch?v=aHm36-na4-4 
"
" Articles:
"
" - http://alexpounds.com/blog/2014/06/06/the-vimrc-antiques-roadshow
"
" - http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"
" - https://vimways.org/2018/from-vimrc-to-vim/ - Good article on storing your
"   config in your .vim folder rather than putting everything in one massive
"   .vimrc
"
" - https://www.reddit.com/r/vim/wiki/vimrctips
"
" Notable RC files:
" - https://bitbucket.org/sjl/dotfiles/src/562b7094aad5c602c6228c1d89f69d0abb3bab6b/vim/vimrc?at=default&fileviewer=file-view-default 
" - https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
"
" Note, you can use K within this file to open the relevant help page
" }}}

" Vimscript notes {{{
" ---------------
" use | to split up two commands
" == depends on ignorecare setting (use ==#)
" functions must start with a capital (if they are unscoped)
"
" variables have various scopes:
"  g:var    - global
"  b:var    - local to buffer
"  l:var    - local to function
"  a:var    - a function arg
"  t:var    - local to tabpage
" See :internal-variables
" }}}

" .vim folder {{{
" ----------
"
" See https://learnvimscriptthehardway.stevelosh.com/chapters/42.html
"
" .vim/
"     plugged/             # Plugins installed with vim-plug
"     plugins/             # These run once every time Vim starts. They should contain code that you want loaded in every
"                            Vim session.
"     ftdetect/            # Run every time Vim starts. These should set-up autocommands that 
"                            detect and set the filetype of files and NOTHING ELSE
"     ftplugin/            # Per-filetype settings (these run when any buffer's filetype is set)
"                          # Should only set buffer-local options or they would overwrite options for all open buffers
"     indent/
"         htmldjango.vim   # Improved htmldjango indent script which handles
"                            block indentation (which the standard file doesn't).
"     after/               # Vim files sourced AFTER dependencies (better for overriding)
"         ftplugins/
"     autoload/            # Plugin code that only loads when it's actually needed.
"         plug.vim         # Vim-plug
"

"
" At start-up Vim sources all files in plugins folders in $RUNTIMEPATH. This
" is the best place to store things that are language agnostic and only need
" to be sourced once.
"
" When a new file-type buffer is loaded Vim sources all
" ftplugin/{filetype}.vim files in $RUNTIMEPATH
"
" Put Vim files in after to ensure they get sourced AFTER all core/bundle
" version have run. This is how you OVERRIDE.
"
" See
" - https://vimways.org/2018/from-vimrc-to-vim/
"
" }}}

" Vim-plug and plugins {{{
" ------------------------
" Plugins managed with vim-plug: https://github.com/junegunn/vim-plug
" Available commands: https://github.com/junegunn/vim-plug#commands
"   :PlugUpgrade - upgrade vim-plug
"   :PlugUpdate  - update plugins

call plug#begin("~/.vim/plugged")

" Editing 
" -------

" Mappings for editing surrounding delimiters, tags etc, eg
"   cs"<em>     => Change Surrounding quotes to <em> tags
"   ysiw[       => applY Surrounding brackets to word (iw) or other text object
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Mapping for jumping between lists, eg:
"   [q  => previous quickfix location
"   ]q  => next quickfix location
"   [Q  => first quickfix location
"   ]Q  => last quickfix location
"   [n  => previous conflict marker
"   ]n  => next conflict marker
Plug 'tpope/vim-unimpaired'

" Commands for common Unix shell commands
"   :Delete => delete buffer and file on disk
"   :Mkdir  => mkdir
" https://github.com/tpope/vim-eunuch
Plug 'tpope/vim-eunuch'

" Zen-mode for editing:
" https://github.com/junegunn/goyo.vim
Plug 'junegunn/goyo.vim'

" Non-standard text-objects
" -------------------------
" See https://codeinthehole.com/tips/vim-text-objects/

" Provides lots of text-objects
"   Use one of , . ; : + - = ~ _ * # / for delimited strings
"   Use a for a function arg
" https://github.com/wellle/targets.vim
Plug 'wellle/targets.vim'

" Use 'i' as a text obj for an indented block
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'  " requirement of vim-textobj-indent and vim-textobj-line

" Use 'l' for the whole line (useful with vim-surround)
Plug 'kana/vim-textobj-line'

" Use 'e' for entire buffer
Plug 'kana/vim-textobj-entire'

" Use 'f' for function, 'c' for class
Plug 'bps/vim-textobj-python'

" Use 'c' for comment block
Plug 'glts/vim-textobj-comment'

" Custom text objects for Django templates
"   Use 'db' for block
"   Use 'df' for for loop
"   Use 'dv' for {{ var }}
"   Use 'dt' for {% tag %}
" Plus others starting with d
Plug 'mjbrownie/django-template-textobjects'

" Navigation
" ----------

" Quick file/buffer/tag searching (faster than CtrlP)
" ctrl-v - open file in split
"
" Commands:
"
"     :GFiles - git files
"     :Colors - colorschemes
"     :Lines  - lines in open buffers
"     :Commits - git commits
"     :Tags - tags from project
"     :BTags - tags from buffer 
"     :History - buffer history
"
" See https://github.com/junegunn/fzf.vim#commands
"
"
" Some leader-mappings defined for these below too.
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Shows 'Match X of Y' in command bar
" Plug 'henrik/vim-indexed-search'

" Syntax highlighting and indentation
" -----------------------------------

" Language pack with syntax and indent files for a range of language

" Disable markdown from Polyglot as we're installing a separate extension. This
" needs to be defined before vim-polyglot is loaded.
let g:polyglot_disabled = ['markdown', 'pascal']

Plug 'sheerun/vim-polyglot'

" Better markdown support than that provided by vim-polyglot. Vim-polyglot
" already provides the indent and syntax parts of this plugin, but the folding
" part is useful too so we install it separately and disable markdown support from polyglot.
"
" Useful features include:
" - folding
" - highlighting of fenced code blocks
" - highlighting of front-matter
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" Better YAML folding. There's nothing in the standard library and this is
" better than just setting foldmethod=indent.
Plug 'pedrohdz/vim-yaml-folds'

" Support for Hashicorp Sentinel buffers (not yet included in polyglot)
Plug 'hashicorp/sentinel.vim'

" Git integration 
" ---------------

" Git(hub) integration
" :Gstatus
" :Gbrowse! - copy Github URL to clipboard
Plug 'tpope/vim-fugitive'

" Github integration for fugitive
Plug 'tpope/vim-rhubarb'

" More sophisticated last-position opening which ignores gitcommit
Plug 'dietsche/vim-lastplace'

" Linting 
" -------

" https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'

" HTML editing
" ------------

" A quick way of writing tags - use C-K to expand the shorthand syntax
" eg .container > .wrapper > ul > li.item * 4
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

" Color scheme
" ------------

" See http://vimcolors.com/
Plug 'jnurmine/Zenburn'

" Debugging
" ---------

" Provides a slew of useful commands like
" https://github.com/tpope/vim-scriptease
"
"   :Messages
"   :Scriptnames
"   :Verbose
"   zS - show active syntax highlight group under the cursor
Plug 'tpope/vim-scriptease'

call plug#end()

" }}}

" Core {{{
" ----

" Switch syntax highlighting on when the terminal has colors
if &t_Co > 2 || has("syntax")
    syntax on
endif

" Source indent/ftplugins for filetypes
filetype indent plugin on  

" }}}
 
" Leader keys {{{
" ----------- 
" Comma is easy to type
let mapleader = ","
let maplocalleader = ","
let g:mapleader = ","
" }}}

" Editing behaviour {{{
set backspace=indent,eol,start          " Allow backspacing over everything in insert mode
set scrolloff=1                         " Controls when to scroll window vertically
set scrolloff=5                         " Controls when to scroll window sideways
set showmatch                           " Show matching delimiters
set showmode                            " Show mode changes
set matchtime=1                         " Jump to matching bracket for 1/10ths of a second
set autoindent                          " Always set autoindenting on
set copyindent                          " Copy previous indentation
set nosmartindent
set nowrap                              " Don't word wrap
set linebreak                           " Don't split words when wrapping 
set shiftround                          " Round indent to multiple of 'shiftwidth'
set smarttab                            " Allow backspacing of a shiftwidth of spaces
set noeol                               " Prevent a carriage return at end of last line
set lazyredraw                          " Don't redraw while executing macros (for performance)
set nojoinspaces                        " Don't insert two spaces after sentence joins

set tabstop=4                           " Length of tab in spaces
set softtabstop=4                       " Number of spaces to add when you hit <tab>
set expandtab                           " Expand tabs into spaces
set shiftwidth=4
set formatoptions=tcqo2j                " Control how gq behaves see `fo-table`
                                        " t = wrap to textwidth
                                        " c = insert leading comment char automatically
                                        " q = apply when using gq
                                        " o = insert leading comment char when hitting o
                                        " 2 = control indenting of para (needed for Python docstring) 
                                        " j = remove comment markers where it makes sense
                                        
" Control how long Vim waits for another key                                        
set timeoutlen=500                                        

" Treat hyphens as part of a word
set iskeyword+=-

" Treat numbers as decimal (eg when incrementing with C-a)
set nrformats-=octal

" }}}

" Command line behaviour {{{
set completeopt=longest,menuone,preview " Insert mode completion options
set complete-=i
set history=10000                       " Number of lines in command line history
set showcmd                             " Display incomplete commands
set wildmenu                            " Use menu to show command line completions
set wildmode=list:longest,full          " Command-line completion
set wildignore+=*.pyc,*egg-info*        " Define files to ignore
set wildignorecase                      " Case-insensitive tab completion

set shellslash                          " A forward slash is used when expanding filenames
set cmdheight=1
" }}}

" Appearance {{{
set ruler                               " Show the cursor position all the time in the status bar
set confirm                             " Prompt for unsaved files
set title                               " Set window title to filename
set nonumber                            " Set line numbers
let &titleold=""

set winminheight=0                      " Allows windows to be fully squashed
set equalalways                         " Keep windows equally sized
" }}}

" Folding {{{
set foldenable
set foldmethod=syntax                   " Default fold method (Python uses indent)
set foldlevelstart=0                    " Starting fold level for a new buffer
set foldlevel=0                         " Sets the default fold level (folder with a higher level will be closed)
set foldnestmax=2
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" Spelling
" The custom dict lives in ~/.vim/spell/
set spell

" }}}

" Terminal {{{
" --------
if ! has("gui_running")
    set term=xterm-256color
    set termencoding=utf-8
    set ttyfast                         " Faster output (vim updates screen in bigger batches)
endif

set encoding=utf-8                      " Use UTF-8 as the default buffer encoding

" }}}

" Mouse {{{
" -----
set mouse=a                             " Enables use of mouse in all modes
set mousehide                           " Hide mouse when typing
" }}}

" Display {{{
set shortmess=atI                       " Prevent file messages appearing
                                        "   a = use abbreviations
                                        "   t = truncate file message on start
                                        "   U = skip intro message when starting
set visualbell                          " Rather than beeps
set noerrorbells                        
" }}}

" Files/buffers {{{
set hidden                              " Don't abandon unloaded buffers, hide them instead
set fileformats=unix                    " File format
set autowrite                           " Auto-write file if modified on exit
set autoread                            " Auto-load file if it changes elsewhere
set nobackup                            " Don't keep a back-up file, they're annoying
set noswapfile
" }}}

" Searching and highlighting {{{
set wrapscan                            " Wrap searching
set incsearch                           " Do incremental searching
set gdefault                            " Global setting on by default in substituting
set ignorecase                          " Ignore case when searching..
set smartcase                           " ..but use case when search term has an upper-case char
set magic
set hlsearch                            " Highlight all search results (sometimes annoying)
set synmaxcol=200                       " Don't try to highlight long lines (for performance)
set cursorline                          " Highlight the line being edited
set virtualedit=all                     " Allow cursor to move anywhere

" Where to find tag files
set tags=./tags,tags

" Highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Use rg for the :grep program (as it's faster than ag)
"   * use "-t html" to only search one filetype
"   * use "-w" to match on word boundaries
if executable('rg') 
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif 

" }}}

" History  {{{
" -------
"
" Keep undo history between sessions
if has('persistent_undo')
    set undofile
    " Note, this isn't created automatically.
    set undodir=~/.vim/undo
    set undolevels=2000
endif

" }}}

" Command-mode mappings {{{
" ---------------------

" Existing command-line special chars:
"   CTRL-R "    -> insert unnamed register
"   CTRL-R %    -> insert current filename
"   CTRL-R /    -> insert last search
"   CTRL-V ...  -> insert next non-digit literally
"   CTRL-B, CTRL-E ...  -> cursor to beginning/end of line
"   CTRL-W      -> delete word
"   CTRL-U      -> delete back to start of line
"   CTRL-R CTRL-W      -> insert Word under the cursor
"   CTRL-R CTRL-A      -> insert WORD under the cursor

" Emacs-style command-line
:cnoremap <C-A>	<Home>
:cnoremap <C-E>	<End>

" Use %% to expand to directory of current file.
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Custom function to call ripgrep with appropriate args via system call rather
" than in parent shell. This avoids clogging up your shell and the hit-enter prompt.
" It isn't always clear if there are not results though.
"
" For multi-word searches, need to use single quotes.
"
" See https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
"
" This has been tweaked and tested with:
"
"    :Grep 'foo bar' --- multi-word queries work (but need single quotes)
"    :Grep 'query\b' --- check word boundaries (and other regex special chars) work

function! Grep(...)
    let cmd = join([&grepprg] + [join(a:000, ' ')], ' ')
    return system(cmd)
endfunction

command! -nargs=+ -complete=file_in_path Grep  cexpr Grep(<f-args>) | normal zi
command! -nargs=+ -complete=file_in_path LGrep lexpr Grep(<f-args>)

" Correct :grep to :Grep
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

" }}}

" Operator-pending mappings {{{ 
" -------------------------
" http://learnvimscriptthehardway.stevelosh.com/chapters/15.html
" http://vimdoc.sourceforge.net/htmldoc/map.html#omap-info
"
" Closely related to text objects

" Text object for next set of (parentheses)
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap an( :<c-u>normal! f(va(<cr>

" }}}

" Abbreviations {{{
" -------------

" Auto-correct common typos
iabbrev si is
iabbrev tehn then
iabbrev acocunt account

" }}}

" Plugin config and mappings {{{
" ==========================

" FZF
" ---

" Map leader keys to common actions

" Search for files
nnoremap <leader>f :Files<cr> 

" Search within files
nnoremap <leader>g :Rg<cr>

" Search open buffers
nnoremap <leader>b :Buffers<cr>

" Search tags
nnoremap <leader>s :Tags<cr>

" Disable preview window (takes up too much screen)
let g:fzf_preview_window = ''

" Redefine :Rg command to not search filenames but only content (see https://github.com/junegunn/fzf.vim/issues/346
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" Fugitive
" --------

" Don't print escape codes from pre-commit hook
let g:fugitive_pty = 0

" Copy URL for selected lines on master branch to clipboard.
vnoremap <leader>gb :Gbrowse! master:%<cr> 

" Open URL for current file on master branch
noremap <leader>gB :Gbrowse master:%<cr> 

" Markdown
" --------
" See https://github.com/plasticboy/vim-markdown#options

" Allow folding as useful for large docs with lots of sections
let g:vim_markdown_folding_disabled = 1

" Fold heading in with the contents
let g:vim_markdown_folding_style_pythonic = 1

" Don't use the shipped key bindings
let g:vim_markdown_no_default_key_mappings = 1

" Indentation for new lists. We don't insert bullets as it doesn't play nicely
" with gq formatting. It relies on a hack of treating bullets as comment characters. 
" See https://github.com/plasticboy/vim-markdown/issues/232
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0

" Syntax extensions (mainly for Hugo blogging)
let g:vim_markdown_fenced_languages = ['php', 'py=python', 'js=javascript', 'bash=sh', 'viml=vim']
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1

" Sparkup
" -------

" Use C-K to expand
let g:sparkupExecuteMapping = "<C-K>"
let g:sparkupNextMapping = "<NOP>"

" Polyglot
" --------

" Format buffer before saving
let g:terraform_fmt_on_save = 1

" Puppet - align hashes (while editing)
let g:puppet_align_hashes = 1


" Ale
" ---
" Note, language-specific linters are defined in ftplugin modules

let g:ale_enabled = 1
let g:ale_completion_enabled = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_fix_on_save = 1

" Customise warning format to include linter name
let g:ale_echo_msg_format = '[%linter%] %code%: %s'

" Jump between syntax errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" MatchParen
" ----------

" Set timeout (in ms) as 44_Highlight_Matching_Pair seems to slow editing some buffers
" down. See https://vi.stackexchange.com/questions/5128/matchpairs-makes-vim-slow
let g:matchparen_timeout = 10
let g:matchparen_insert_timeout = 10

" }}}
 
" Mappings {{{
" ===========
 
" GLOBAL
" ------

" Make useless key useful again (UK Mac keyboard issue...)
set pastetoggle=§

" Copy to system clipboard
map <leader>y "*y

" Replace word under cursor with top spelling suggestion
map <leader>z 1z=

" Open current buffer in its own tab
map <leader>o :tab sp<cr>

" Fix gx to open the URL under the cursor, like it used to.
" https://github.com/vim/vim/issues/4738
nmap gx yiW:!open <cWORD><CR> <C-r>" & <CR><CR>

" INSERT MODE
" -----------

" Alias for escape - see http://cloudhead.io/2010/04/24/staying-the-hell-out-of-insert-mode/
inoremap kj <ESC>
inoremap <ESC> <NOP>

" No more cursor keys! 
inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>

" Mimic some Emacs shortcuts

" Delete line (replaces insert one shiftwidth of indent)
inoremap <C-d> <ESC>ddi     

" Jump to end of line (replaces insert the character below the cursor)
inoremap <C-e> <ESC>A

" Jump to start of line (replaces insert previously inserted text)
inoremap <C-a> <ESC>I

" Make word under cursor uppercase (delete to start of line)
inoremap <C-u> <ESC>viwUi

" Indent current line
inoremap <C-=> <ESC>V=i

" Format current paragraph
inoremap <C-f> <ESC>vipgqi

" Save and quit from insert mode
inoremap <leader><leader> <ESC>:wq<CR>


" NORMAL MODE
" -----------

" Alias for : to avoid hitting shift all the time
nnoremap ; :

" Disable cursors
nnoremap <Up>    <NOP>
nnoremap <Down>  <NOP>
nnoremap <Left>  <NOP>
nnoremap <Right> <NOP>

" Search codebase for word under cursor (v useful)
nnoremap gw :execute "Grep " expand('<cword>') <cr>

" Search codebase for current filename
nnoremap gW :execute "Grep " expand('%:t') <cr>

" Swap <c-]> and g<c-]>
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>

" Also use K as a tag look-up command 
" Note, this clobbers the run `keywordprg` map
nnoremap K g<C-]>

" Reinstate keyword lookup map
nnoremap ,h K

" Default ctag invocation. Ensure project has an appropriate .ctags.d/ folder
" if the default config isn't right.
nnoremap <leader>ct :!ctags<cr>

" Jump to alternate file
nnoremap <leader><leader> <c-^>

" Make yank consistent with other commands
nnoremap Y y$

" Cursor moves up/down on the screen, not lines in the file
nnoremap j gj
nnoremap k gk

" Format paragraph
nnoremap Q gqap

" Stop cursor jumping when joining lines
nnoremap J mzJ`z

" Put result in centre of window when jumping between search results
nnoremap n nzz
nnoremap N Nzz

" Typos
nnoremap :W :w
nnoremap :E :e
nnoremap :Q :q

" Use backspace to turn off highlighted search terms
nnoremap <BS> :nohlsearch<CR>

" Select the last thing pasted (compliments gv which selects the last visual
" selection).
nnoremap gV `[v`]

" Merge conflicts. Use ]c to jump between chunks.
map <leader>1 :diffget LOCAL<cr>
map <leader>2 :diffget BASE<cr>
map <leader>3 :diffget REMOTE<cr>

" VISUAL MODE
" -----------

" Leave cursor at the end of the yanked block
vnoremap y y']

" Leading mappings
" ----------------

" Faster saving and quiting
nnoremap <leader>w :wa<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wqa<CR>

" Open vimrc in new window
nnoremap <leader>ve :e ~/.vim/vimrc<CR>

" VISUAL MODE
" -----------

" When in visual mode, retain visual selection after action
function! ShiftAndKeepVisualSelection(cmd) 
    set nosmartindent
    if mode() =~ '[Vv]'
        return a:cmd . ":setlocal smartindent\<CR>gv" 
    else
        return a:cmd . ":setlocal smartindent\<CR>"
    endif 
endfunction

vnoremap <expr> > ShiftAndKeepVisualSelection(">") 
vnoremap <expr> < ShiftAndKeepVisualSelection("<")

" }}}

" Status bar {{{
set showmode                            " Display which mode we're in
set laststatus=2                        " Always show status bar
if has('statusline') 
    " Notes:
    " %n = buffer number
    " %f = path to file
    " %y = filetype
    " %l = line number
    " %L = total lines in file
    " 
    set statusline=%n\:\ %f\ %y\ 
    set statusline+=%=
    set statusline+=%#warningmsg#
    set statusline+=%*
    set statusline+=col\ %c\ line\ %l/%L
endif
" }}}

" Autocommands {{{
" ------------
" All autocmds should be in a group so they can be re-sourced
" without side-effect. We use a single group that we assign each autocommand to.
"
" http://learnvimscriptthehardway.stevelosh.com/chapters/12.html
" https://gist.github.com/romainl/6e4c15dfc4885cb4bd64688a71aa7063

augroup MyAutoCommands
    autocmd!
augroup END

" Only show the cursorline for current buffer in normal mode  
autocmd MyAutoCommands WinLeave,InsertEnter * set nocursorline
autocmd MyAutoCommands WinEnter,InsertLeave * set cursorline

" Resize splits when a window is created, closed or resized
autocmd MyAutoCommands WinEnter,VimResized * :wincmd =

" Open quickfix window after make/grep if there are results
autocmd MyAutoCommands QuickFixCmdPost cexpr cwindow
autocmd MyAutoCommands QuickFixCmdPost lexpr lwindow

" }}}

" Commands {{{
" -------

" Define :Slack to open a Goyo buffer in markdown filetype for drafting
" messages for Slack.
function! OpenSlackWindow() 
    enew
    Goyo
    setlocal wrap ft=markdown
    echo "Ready to draft Slack message..."
endfunction

command Slack call OpenSlackWindow()

" }}}

" Project specific settings {{{
" -------------------------

function! ConfigureKrakenCore()
    nnoremap <leader>ct :!ctags --languages=python<cr>
endfunction

autocmd BufRead */kraken-core/* call ConfigureKrakenCore()

" }}}

" Colorscheme  {{{
" -----------
" These needs to be near the end of ~/.vimrc for some reason
if &t_Co >= 256 || has("gui_running")
    " Don't complain if colorscheme doesn't exist (zenburn)
    silent! colorscheme zenburn
    set background=dark  
else
    set background=light
    colorscheme solarized
endif

" Tweaks for markdown rendering
" List of colors: http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
highlight htmlH1 guifg=#42dff4 gui=bold ctermfg=51 ctermbg=None cterm=bold
highlight htmlH2 guifg=#af84e0 gui=bold ctermfg=45 ctermbg=None cterm=bold
highlight htmlH3 guifg=#aae295 gui=bold ctermfg=39 ctermbg=None cterm=bold
highlight htmlH4 guifg=#e9f2b3 gui=bold ctermfg=33 ctermbg=None cterm=bold

" Goyo
let g:goyo_width = 80

" }}}

" Quickfix  {{{
" -----------
" Throwaway function for using with :cdo

function! FixQuickfixEntry()
    " Example the line of the error to determine what fix is required.
    let line = getline('.')
    if line =~ 'as e:$'
        " Handle scenario of unused exception variable
        s/ as e:/:/
    elseif line =~ '^\s\+\w\+ = factory'
        " Handle scenario of unused test factory variable
        normal _
        normal 2dw
    else
        echom "Unable to fix"
    endif
endfunction

" }}}

