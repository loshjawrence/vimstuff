﻿" vim is not great for code base naviation and language aware autocomplete.
" It's the skyrim of text editors. Unusable without certain mods.
let baseDataFolder="~/.vim"
if has("win32")
    if has("nvim")
        let baseDataFolder="~/AppData/Local/nvim"
    else
        let baseDataFolder="~/vimfiles"
    endif
else
    if has("nvim")
        let baseDataFolder="~/.local/share/nvim"
    endif
endif
let &runtimepath.=',' . baseDataFolder
let &runtimepath.=',' . baseDataFolder . "/after"
let &packpath = &runtimepath

set nocompatible " vim, not vi
syntax on        " syntax highlighting
syntax enable    " syntax highlighting

" FILETYPE
" Associate filetypes with other filetypes
autocmd BufRead,BufNewFile *.shader set filetype=c
autocmd BufRead,BufNewFile *.vert   set filetype=c
autocmd BufRead,BufNewFile *.frag   set filetype=c
autocmd BufRead,BufNewFile *.json   set filetype=json
autocmd BufRead,BufNewFile *.md     set filetype=markdown

" TODO: LSP for code completion options:
" ccls/LanguageClient-neovim/nvim-gdb/ncm2/tagbar/nerdtree
" https://github.com/MaskRay/ccls
" https://github.com/neoclide/coc.nvim
" https://vim.fandom.com/wiki/Using_vim_as_an_IDE_all_in_one
" https://vim.fandom.com/wiki/Omni_completion

filetype plugin indent on  " try to recognize filetypes and load rel' plugins
noremap <space> <nop>
let mapleader="\<space>" " Map the leader key to SPACE
" Type :help fo-table (or hit K when cursor over fo-table) to see what the different letters are for formatoptions
set formatoptions=rqj
if has("win32")
    set guifont=Consolas:h9    " set text to consolas, size
else
    set guifont=Ubuntu:h10    " set text to consolas, size
endif

" The different events you can listen to http://vimdoc.sourceforge.net/htmldoc/autocmd.html#autocmd-execute
" autocmd-events for executing : commands (full explanations: autocmd-events-abc)

set nrformats-=octal
set number              " Show line numbers
set background=dark     " tell vim what the background color looks like
set backspace=indent,eol,start " allow backspace to work normally
set history=200         " how many : commands to save in history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set nowrapscan          " Don't autowrap to top of tile on searches
set ignorecase
set smartcase
set laststatus=2        " Always display the status line
set autowrite           " Automatically :write before running commands
set magic               " Use 'magic' patterns (extended regular expressions).
set guioptions=         " remove scrollbars on macvim
set noshowmode          " don't show mode as airline already does
set mouse=a             " enable mouse (selection, resizing windows)
set nomodeline          " Was getting annoying error on laptop about modeline when opening files, duckduckgo said to turn it off

set tabstop=4           " Use 4 spaces for tabs.
set shiftwidth=4        " Number of spaces to use for each step of (auto)indent.
set expandtab           " insert tab with right amount of spacing
set shiftround          " Round indent to multiple of 'shiftwidth'
set termguicolors       " enable true colors
set hidden              " enable hidden unsaved buffers
silent! helptags ALL    " Generate help doc for all plugins

set ttyfast           " should make scrolling faster
set lazyredraw        " should make scrolling faster

" visual bell for errors
set visualbell

" jump to tag. / will do fuzzy match
" nnoremap <leader>j :tjump /

" list the buffers and prepare open buffer command
" nnoremap gb :ls<CR>:b<space>

set wildignorecase
set wildmenu                        " enable wildmenu
set wildmode=list:longest,list:full " configure wildmenu

" text appearance
set textwidth=80
set nowrap                          " Don't word wrap

" trailing whitespace, and end-of-lines. VERY useful!
" Also highlight all tabs and trailing whitespace characters.
" set listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
" set list                            " Show problematic characters.
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$\|\t/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$\|\t/

" set where swap file and undo/backup files are saved
set nowritebackup
set noswapfile
let &backupdir=baseDataFolder
let &directory=baseDataFolder

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" To ALWAYS use the clipboard for ALL operations
" instead of interacting with the '+' and/or '*' registers explicitly
if has("nvim") " didn't work in gvim
    set clipboard+=unnamedplus
endif

" Always use vertical diffs
set diffopt+=vertical

" Enable spellchecking for Markdown
autocmd FileType markdown setlocal spell
" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" add support for comments in json (jsonc format used as configuration for
" many utilities)
autocmd FileType json syntax match Comment +\/\/.\+$+

" notify if file changed outside of vim to avoid multiple versions
au FocusGained,BufEnter,WinEnter,CursorHold,CursorHoldI * :checktime

" set UTF-8 encoding
set enc=utf-8 fenc=utf-8 termencoding=utf-8

" Plugins. Execute :PlugInstall for any new ones you add
" Auto install the vim-plug pluggin manager if its not there
let plugDotVimLocation=baseDataFolder . "autoload/plug.vim"
if has("nvim")
    let plugDotVimLocation=baseDataFolder . "site/autoload/plug.vim"
endif
" if empty(glob(plugDotVimLocation))
" need to do execute with quotes and stuff probably
"   silent !curl -fLo plugDotVimLocation --create-dirs
"         \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif
call plug#begin(baseDataFolder . '/bundle') " Arg specifies plugin install dir
" Bread and butter file searcher.
" <space>f to search for tracked files in git repo.
" Lots of other powerful stuff see git repo for details. Install ripgrep (choco install ripgrep) and do <space>r for a grep search (git aware).
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Not reliable (like all ctags trash)
" Tag file management, should use Exhuberant Ctags
" Plug 'ludovicchabant/vim-gutentags'
" set statusline+=%{gutentags#statusline()}
" " " Plug 'skywind3000/gutentags_plus' " Need to explore this more, are its search cases common or niche

" Plug 'w0rp/ale'

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1

" " " MAKE SURE TO :UpdateRemotePlugins if seeing 'no notification handler' message for LanguageClinet
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
"
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
"     \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
"     \ 'python': ['/usr/local/bin/pyls'],
"     \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
"     \ }

" nnoremap <F6> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" WIndows key repeat rate: https://ludditus.com/2016/07/15/microsoft-the-keyboard-repeat-rate-and-sleeping-how-to-work-around-their-idiocy/
" linux search keyboard set to 200ms delay, 40c/s
Plug 'vim-airline/vim-airline' " see 'powerline/fonts' for font installation 'sudo apt install fonts-powerline'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" Enable repeat for supported plugins
Plug 'tpope/vim-repeat'

" Type s and a char of interesst then the colored letters at the char to jump to it.
Plug 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_use_upper = 1
let g:EasyMotion_keys =   'FJDKSLA;GHEIRUWOQPTYNVMCBZX' " should sort from easy to hard (left to right)
let g:EasyMotion_smartcase = 1
" Jump to anywhere you want with minimal keystrokes, with just one key binding. `s{char}{label}`
" overwin can jump across panes. f2 is 2 char search
" This will search before and after cursor over panes
" nmap s <Plug>(easymotion-overwin-f)
" extend the native t,T,f,F commands to all visible lines, not just current line
" nmap f <Plug>(easymotion-f)
" nmap F <Plug>(easymotion-F)
" nmap t <Plug>(easymotion-t)
" nmap T <Plug>(easymotion-T)
" This will search before and after cursor in current pane
nmap s <Plug>(easymotion-s)

" Syntax highlighting for a ton of languages
Plug 'sheerun/vim-polyglot'

" Plug 'godlygeek/tabular' " Aligning selected text on some char or regexK
" vnoremap  <leader>t<bar>  :Tabularize  /\|<cr>
" vnoremap  <leader>t/      :Tabularize  /\/\/<cr>
Plug 'vim-scripts/star-search' " star search no longer jumps to next thing immediately. Can search visual selections.
Plug 'kassio/neoterm' " Only use this for Ttoggle (term toggle) any way to do this myself?
" Toggle f8 to see code symbols for file. Need to install Exuberant ctags / Universal ctags via choco(MS Windows))
Plug 'majutsushi/tagbar' " good for quickly seeing the symobls in the file so you have word list to search for
map <F8> :TagbarToggle<cr>
" netwr is possibly than nerdtree
map <F7> :20Lex<CR><c-w><c-l>
        " How to start in vert line mode
        " Hitting enter on the f1 help line will cycle the commands that it displays on that line
        " <cr>	Netrw will enter the directory or read the file      |netrw-cr|
        "   t	Enter the file/directory under the cursor in a new tab|netrw-t|
        "   v	Enter the file/directory under the cursor in a new   |netrw-v|
        "    	browser window.  A vertical split is used.
        "   o	Enter the file/directory under the cursor in a new   |netrw-o|
        "    	browser window.  A horizontal split is used.
        "        Useful if you want another netwr window below the current one for differnt parts of the repo
        " <c-h>	Edit file hiding list                                |netrw-ctrl-h|
        " <c-l>	Causes Netrw to refresh the directory listing        |netrw-ctrl-l|
        "   d	Make a directory                                     |netrw-d|
        "   D	Attempt to remove the file(s)/directory(ies)         |netrw-D|
        "   R	Rename the designated file(s)/directory(ies)         |netrw-R|
        "   %	Open a new file in netrw's current directory         |netrw-%|
        "   s	Select sorting style: by name, time, or file size    |netrw-s|
        "   S	Specify suffix priority for name-sorting             |netrw-S|
        "   gb	Go to previous bookmarked directory                  |netrw-gb|
        "   gh	Quick hide/unhide of dot-files                       |netrw-gh|
        "   i	Cycle between thin, long, wide, and tree listings    |netrw-i|
        "   mb	Bookmark current directory                           |netrw-mb|
        "   mc	Copy marked files to marked-file target directory    |netrw-mc|
        "   md	Apply diff to marked files (up to 3)                 |netrw-md|
        "   me	Place marked files on arg list and edit them         |netrw-me| " Decides to open them in the fucking netwr window. vim is terrible
        "   mf	Mark a file                                          |netrw-mf| " Must do one at a time. cant leverage visual select? vim is terrible.
        "   mF	Unmark files                                         |netrw-mF|
        "   mh	Toggle marked file suffices' presence on hiding list |netrw-mh|
        "   mm	Move marked files to marked-file target directory    |netrw-mm|
        "   mp	Print marked files                                   |netrw-mp|
        "   mr	Mark files using a shell-style |regexp|              |netrw-mr|
        "   mg	Apply vimgrep to marked files                        |netrw-mg|
        "   mu	Unmark all marked files                              |netrw-mu|
        "   p	Preview the file                                     |netrw-p|
        "   P	Browse in the previously used window                 |netrw-P|
        "   qb	List bookmarked directories and history              |netrw-qb|
        "   qF	Mark files using a quickfix list                     |netrw-qF|
        "   qL	Mark files using a |location-list|                     |netrw-qL|
        "   r	Reverse sorting order                                |netrw-r|


" FONT SIZE FONT ZOOM
" neovim seems to work with both, gvim works with niether
" theres a neovim gtk version that works for linux and windows
" Plug 'schmich/vim-guifont' " quickly increase decrease font size in guis
" let guifontpp_size_increment=1 
" let guifontpp_smaller_font_map="<c-->" 
" let guifontpp_larger_font_map="<c-=>" 
" " does not work on gvim windows, works on nvim windows
" " increase decrease font size 
" nnoremap <C-=> :silent! let &guifont = substitute(
"             \ &guifont,
"             \ ':h\zs\d\+',
"             \ '\=eval(submatch(0)+1)',
"             \ '')<CR>
" nnoremap <C--> :silent! let &guifont = substitute(
"             \ &guifont,
"             \ ':h\zs\d\+',
"             \ '\=eval(submatch(0)-1)',
"             \ '')<CR>

" if has("win32")
"     function! FontSizePlus ()
"       let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
"       let l:gf_size_whole = l:gf_size_whole + 1
"       let l:new_font_size = ':h'.l:gf_size_whole
"       let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
"     endfunction
"
"     function! FontSizeMinus ()
"       let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
"       let l:gf_size_whole = l:gf_size_whole - 1
"       let l:new_font_size = ':h'.l:gf_size_whole
"       let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
"     endfunction
" else
"     function! FontSizePlus ()
"       let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
"       let l:gf_size_whole = l:gf_size_whole + 1
"       let l:new_font_size = ' '.l:gf_size_whole
"       let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
"     endfunction
"
"     function! FontSizeMinus ()
"       let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
"       let l:gf_size_whole = l:gf_size_whole - 1
"       let l:new_font_size = ' '.l:gf_size_whole
"       let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
"     endfunction
" endif
" nmap <c--> :call FontSizeMinus()<CR>
" nmap <c-=> :call FontSizePlus()<CR>

Plug 'tomtom/tcomment_vim' " Comment selected lines with gc, current line with gcc, scope with gcip{, text block with gcip, and so on.K
Plug 'wellle/targets.vim' " Can target next(n) and last(l) text object. Adds new delimiter pairs and can target function args with a. Ex: dina cila vina function(cow, mouse, pig) |asdf|asdf| [ thing 1 ] [thing  2]

" Smooth scrolling
Plug 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 8
let g:comfortable_motion_friction = 3000.0
let g:comfortable_motion_air_drag = 0.0
nnoremap <silent> <c-e> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 0.7)<cr>
nnoremap <silent> <c-y> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -0.7)<cr>
nnoremap <silent> <c-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 1)<cr>
nnoremap <silent> <c-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -1)<cr>
nnoremap <silent> <c-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 1.5)<cr>
nnoremap <silent> <c-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -1.5)<cr>
" Colorschemes
Plug 'AlessandroYorba/Alduin'
if has("nvim") || has("gui_running")
    colorscheme alduin2 " alduin3 has the white tabs for terminal, doesnt work in gvim, alduin2 works in gvim and nvim
else 
    colorscheme alduin  " alduin3 has the white tabs for terminal, doesnt work in gvim, alduin2 works in gvim and nvim
endif
call plug#end()
"
" SEARCH
" * and # search does not use smartcase
" replace word under cursor in entire file
" test this thing
" test
" test this thing
" test
" test THIS thing
" test
" Test
" see s_flags and substitute. /I forces case-sensitive matching
" Visually selected text, don't ignore case
" yank first, % for current file, \V for not having to escape symbols,
" <c-r>" to paste from yank buffer, /I forces case-sensitive matching
" you can prepare a series of commands separated by |. Buy you must escape it
" norm or normal means execute the following key sequence in normal mode.
nnoremap <leader>sr :%s/\V<c-r><c-w>//gI \| normal <c-o><c-left><c-left><c-left><left><left><left><left>
vnoremap <leader>sr y:%s/\V<c-r>"//gI \| normal <c-o><c-left><c-left><c-left><left><left><left><left>
if has("nvim")
    set inccommand=nosplit " Remove horizontal split that shows a preview of whats changing
endif

" see pattern for 'very no magic'. Only \ has meaning
nnoremap / /\V
vnoremap / /\V

" NAVIGATION WINDOW RESIZE
" Only seems to work for gvim on windows
if has("win32") && has("gui_running")
    set lines=999
    set columns=255
    " Resize window
    " grow window horizontally
    nnoremap <c-left> :set columns-=2<cr>
    nnoremap <c-right> :set columns+=2<cr>
    " grow window vertically
    nnoremap <c-down> :set lines-=2<cr>
    nnoremap <c-up> :set lines+=2<cr>
endif
" nvim_win_config
" grow splits horizontally
nnoremap <s-left> :vertical resize -2<cr> 
nnoremap <s-right> :vertical resize +2<cr>
" grow splits vertically
nnoremap <s-down> :res -2<cr>
nnoremap <s-up> :res +2<cr>

" If you set the winheight option to 999, the current split occupies as much of the screen as possible(vertically)
" and all other windows occupy only one line (I have seen this called "Rolodex mode"):
" set winheight=999
" sideways version:
" set winwidth=999
" To increase a split to its maximum height, use Ctrl-w _.
" To increase a split to its maximum width, use Ctrl-w |. 
"
" cycle through tabs, left and right
noremap <c-x> gT
noremap <c-a> gt

" Vert split navigaton
inoremap <c-h> <Esc><c-w>h
inoremap <c-j> <Esc><c-w>j
inoremap <c-k> <Esc><c-w>k
inoremap <c-l> <Esc><c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l
" TERMINAL
" Go to insert mode when switching to a terminal
au BufEnter * if &buftype == 'terminal' | startinsert | endif
" Distinguish terminal by making cursor red
highlight TermCursor ctermfg=red guifg=red
" No idea why this repmap works the first time then breaks there after. It manually works
" nnoremap <silent> <leader><leader> :vertical botright Ttoggle<cr><c-w>l
" quickly toggle term with space space
func! s:toggleTerminal()
    func! s:toggleCheckInsert()
        execute "vertical" "botright" "Ttoggle"
        execute "wincmd" "l"
    endfunc

    execute "nnoremap" "<silent>" "<leader><leader>"
                \ ":call <SID>toggleCheckInsert()<cr>"
endfunc
call s:toggleTerminal()
" Esc quits the termial
if has("nvim")
    tnoremap <Esc> <C-\><C-n>:q<CR>
else
    tnoremap <ESC> <C-w>:q<CR>
endif
" To simulate i_CTRL-R in terminal-mode
tnoremap <expr> <c-r> '<c-\><c-n>"'.nr2char(getchar()).'pi'

" Toggle between header and source for c/cpp files
nnoremap <c-z> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<cr>


" COLORCOLUMN
" Highlight from 81 on in a different color
" let &colorcolumn=join(range(81,999),",")

" CURSORLINE (can be slower)
let g:useCursorline = 1
" purple4 royalblue4
" hi CursorLine  cterm=NONE ctermbg=royalblue4 ctermfg=NONE
hi cursorline  gui=NONE guibg=purple4 guifg=NONE
hi cursorcolumn  gui=NONE guibg=purple4 guifg=NONE
	" You can also specify a color by its RGB (red, green, blue) values.
	" The format is "#rrggbb", where
    " :highlight Comment guifg=#11f0c3 guibg=#ff00ff
if g:useCursorline == 1
    set cursorline
    autocmd BufEnter * set cursorline
    autocmd BufLeave * set nocursorline
else
    set nocursorline
    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline
endif

" Press Enter to turn off search highlights, and flash the location of the cursor
function! Flash()
    set cursorline cursorcolumn
    redraw
    sleep 100m

    set nocursorcolumn
    if g:useCursorline == 0
        set nocursorline
    endif
endfunction
nnoremap <cr> :noh<cr>:call Flash()<cr>

" Only hit < or > once to tab indent, can be vis selected and repeated like normal with '.'
nnoremap < <<
nnoremap > >>

" Indent whole file, turns out to be too painful even for medium files, just do current scope instead
" nnoremap == gg=G<c-o>
nnoremap == =i{<c-o>

" " make getting out of insert mode easier
" " <c-[> is Windows mapping for esc
inoremap <c-[> <Esc>:w<cr>
 " This decided to break. vim is terrible.
" nnoremap <c-[> <Esc>:w<cr>
"
" replay macro (qq to start recording, q to stop)
nnoremap Q @q
" apply macro across visual selection, VG to select until end of file
vnoremap Q :norm @q<cr>

" navigate by display lines
nnoremap j gj
nnoremap k gk

" yank to end of line to follow the C and D convention. vim is terrible
nnoremap Y y$

" Session: save vim session to ./Session.vim, load Session.vim
" Usually just open any text file in root of a repo and type <leader>ss to create Session.vim file in the root of repo.
" Then when I need to load up the seesion again I open the Session.vim file in the root of the repo and type <leader>so to restore my session.
nnoremap <leader>ss :mks!<cr>
nnoremap <leader>so :so Session.vim<cr>:so $MYVIMRC<cr>

" In terminal vi, the alt+a and alt+d keys are actually ^[a and ^[d
" You can see this by typing the key sequence in a command line after doing a
" cat followed by enter or sed -n l followed by enter
" If you type alt-a after that the output will be something like ^[a which is <escape> a
" if not terminal winodw this would just be noremap <a-a> gT
" alt-a will go to next left tab
" Bad to have Esc mappings avoid Alt key since terminal commonly maps Alt to Esc
" noremap <Esc>a gT
" " alt-d will go to next right tab
" noremap <Esc>d gt
" " alt-A will move the current tab to the left
" noremap <Esc>A :tabm -1<cr>
" " alt-D will go to next right tab
" noremap <Esc>D :tabm +1<cr>


" comment to enable Alt+[menukey] menu keys (i.e. Alt+h for help)
set winaltkeys=no " same as `:set wak=no`
" comment to enable menubar
set guioptions-=m
" comment to enable icon menubar
set guioptions-=T

" if has("gui_running")
"     " Move the tab left and right in the tab bar
"     noremap <A-A> :tabm -1<cr>
"     noremap <A-D> :tabm +1<cr>
" endif

" Source the vimrc so we don't have to refresh, edit the vimrc in new tab
nmap <silent> <leader>vs :so ~/.vimrc<cr>
nmap <silent> <leader>ve :vs ~/.vimrc<cr>

" fzf plugin shortcuts :Marks :Tags :Buffers :History :History: :History/ :Files :GFiles :Rg
" down / up / left / right
let g:fzf_layout = { 'down': '~50%' }

" In Neovim, you can set up fzf window using a Vim command
nnoremap <leader>l :BLines<cr>
nnoremap <leader>L :Lines<cr>
nnoremap <leader>t :BTags<cr>
nnoremap <leader>T :Tags<cr>
nnoremap <leader>f :GFiles<cr>
nnoremap <leader>F :Files<cr>
" nnoremap <leader>hh :History<cr>
" nnoremap <leader>h/ :History/<cr>
" nnoremap <leader>h: :History:<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>r :Rg<cr> " need to install ripgrep or compile it in rust, not available on ubuntu 18.04

" Make a simple "search" text object, then cs to change search hit, n. to repeat
" http://vim.wikia.com/wiki/Copy_or_change_search_hit
vnoremap <silent> s //e<c-r>=&selection=='exclusive'?'+1':''<cr><cr>
            \:<c-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<cr>gv
onoremap s :normal vs<cr>

" Pretty Json, can be called like other commands with :
command! JSONPRETTY %!python -m json.tool


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" NOTES 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Auto generate remappings, targets.vim does this nicely
" Example: noremap ci, T,ct,
" Add other text objects to perform ci and ca with
" n means jump to next pair, l means jump to last pair
" SINGLE LINE VERSION
" for charBound in [ "<Bar>", "/", "\\", "'", "`", "\"", "_", ".", ",", "*", "-", "&", "^", "+"]
"     for editType in ["c", "y"]
"         execute 'nnoremap ' . editType . 'i'  . charBound . ' T' . charBound . 'ct' . charBound
"         execute 'nnoremap ' . editType . 'in' . charBound . ' f' . charBound . ';T' . charBound . 'ct' . charBound
"         execute 'nnoremap ' . editType . 'il' . charBound . ' F' . charBound . ';f' . charBound . 'cT' . charBound
"     endfor
" endfor

" SEARCH VERSION
" \d is a number
" . is any char
" \. is .
" \s is white space
" \S in non-white space
" \a is letter
" search quote with some non-white stuff in it /".*\S\+.*"
" search quote with white stuff in it /"\s+"
" search quote with nothing /""
" search quote followed by \ or quote followed by any char /"\\\|".
" nnoremap ci" ?"<cr>vNc""<Esc>:noh<cr>i
" nnoremap cin" /".*\S\+.*"<cr>:noh<cr>iasdf
" nnoremap cil" ?".*\S\+.*"<cr>cs""<Esc>:noh<cr>i

"NOTES:
" wow: https://vim.fandom.com/wiki/Power_of_g
" In the "power of g" how do I do the display context of search across all files in project/pwd to do what sublime does?
" highlighing lines then doing a :w TEST will write those lines to TEST
" :r TEST will put lines from test at the cursor
" :r !ls will put the result of ls at the cursor
" Re-flow comments by visually selecting it and hit gq
" :qa! quits all without saving
" :wqa! write and quits all
"  with tcomment_vim installed you can comment lines with gc when they are visually selected
" possibly useful nomral mode keys:
" :%!python -m json.tool // Prettify Json files (choco install python)
" <c-w>gf to open file under cursor in a new tab, gf will open file in this tab
" ; will repeat t/T and f/F (line movement to and find) commonds. , will repeat reverse directio direction
" <c-w><c-w> cycle split windows
" c-w + h,j,k, or l will nav to other splits
" c-w + s,v opens the same buffer in a horiz or vert split
" K will search in man pages for the command under cursor (this has been remapped to to opposite of J)
" :sh will open a shell
" di{ to delete method body, can do this with these as well: " ( [ ' <
" daw deletes around(includes white space) word use this instead of db unless you really need db
" :windo diffthis (diff windows in current tab, :diffoff! to turn it off)
" :g/^\s*$/d global delete lines containing regex(whitespace-only lines)
" :g!/error\|warn\|fail/d opposite of global delete (equivalent to global inverse delete (v//d)) keep the lines containing the regex(error or warn or fail)
" :tab sball -> convert everything to tabs
" gt (next tab) gT(prev tab) #gt (jump to tab #)
" :mks! to save Session.vim in current folder
" :source Session.vim to open the Session.vim saved session
" c-n, c-p tab-like completion pulling from variety of sources (also for prompt navigation, prev, next)
" c-x c-l whole line completion
" c-x c-o syntax aware omnicompletion
" see this for native vim auto complete https://robots.thoughtbot.com/vim-you-complete-me
" clipboard reg 1 yank in word nmode: "1yiw vmode: "
" clipboard reg 1 yank in word nmode: "1yiw vmode: "1y
" paste in word from reg 1: nmode: viw"1p vmode: "1p
" edit file under cursor: gf
" open prevoius file: <c-6> good for toggling .h and .cpp (can also use fzf's :History command <leader>hh)
" paste in word from reg 1: nmode: viw"1p vmode: "1p
" fzf plugin shortcuts :Marks :Tags :Buffers :History :History: :History/ :Files :Rg :GFiles :Windows
" :Vex vertical explorer (can navigate and search like normal vim, READ THE F1 help looks configurable  to work like a tree)
" can turn a split into a tab by doing c-w then T
" zz to center the line you're on in the middle of the screen
" zt to put the line you're on at the top of the screen
" c-y anc c-e scroll up and down keeping the cursor on the same line
" c-x subtracts 1 from number under curosr c-a adds 1
" zE remove all folds
" [{ ]} will jump to beginning and end of a {} scope
" vip will highlight a block bound by blank lines
" % will jump to (), [], [] on a line
" INSERT MODE MOVEMENT:
" CTRL-W    Delete word to the left of cursor
" CTRL-U    Delete everything to the left of cursor
" CTRL-O    Goes to normal mode to execute 1 normal mode command
" COMMAND MODE:
" ctrl-n, p next previous command in history

" [ COMMANDS (The ] key is the forward version of the [ key)
" [ ctrl-i jump to first line in current and included files that contains the word under the cursor
" [ ctrl-d jumpt to first #define found in current and included files matching the word under cursor
" [/ cursor N times back to start of // comment
" [( cursor N times back to unmatched (
" [{ cursor N times back to unmatched {
" [[ cursor N times back to unmatched [
" [D list all defines found in current and lincluded files matching word under cursor
" [I list all lines found in current and lincluded files matching word under cursor
" [m cursor N times back to start of memeber function
" gD go to def or word under cursor in current file
" gd go to def or word under cursor in current function

" REGISTERS
" :reg to list whats in all the registers
" @: uses this register to execute the command again
" Editing macros since they are stored in registers: For example, if you forgot to add a semicolon in the end of that w macro, just do something like :let @W='i;'. Noticed the upcased W? 
" That’s just how we append a value to a register, using its upcased name, so here we are just appending the command i; to the register, to enter insert mode (i) and add a semicolon.
" If you need to edit something in the middle of the register, just do :let @w='<Ctrl-r w>, change what you want, and close the quotes in the end. Done, no more recording a macro 10 times before you get it right.
" "" is the unamed register (d,x,s,c) will go there
" "0 is the last yank, 1-9 are the deletes, youngest to oldest
" ". is THE LAST INSTERTED TEXT, GOOD FOR REPEATED PASTES
" "% is the current file name
" ": most recent command. Ex: if you saved with :w then w will be in this reg
" "+ is the system clipboard for copying into and out of vim
" "# is the name of the last edited file (what vim uses for c-6)
" "= is the expression regiser: This is easier to understand with an example. If, in insert mode, you type Ctrl-r =, you will see a “=” sign in the command line. Then if you type 2+2 <enter>, 4 will be printed. 
" This can be used to execute all sort of expressions, even calling external commands. To give another example, if you type Ctrl-r = and then, in the command line, system('ls') <enter>, the output of the ls command will be pasted in your buffer
" "/ is the search register, the last thing searched for

" INSERT MODE
" c-w deletes word
" c-u deletes line

" Bad but might have nugget of good idea
" Bind p in visual mode to paste without overriding the current register
" bad: this will put you back to your previous visual selection which is annoying, need to figure out how to go back to where you pasted
" nnoremap p pgvy
