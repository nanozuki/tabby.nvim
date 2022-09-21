let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/Projects/github.com/nanozuki/tabby.nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 lua/tabby/feature/lines.lua
badd +1 lua/tabby/init.lua
badd +0 lua/tabby/tabline.lua
badd +1 lua/tabby/feature/buf_name.lua
badd +0 lua/tabby/feature/tab_name.lua
badd +1 term://~/Projects/github.com/nanozuki/tabby.nvim//90617:/usr/local/bin/fish
badd +0 term://~/Projects/github.com/nanozuki/tabby.nvim//90636:/usr/local/bin/fish
argglobal
%argdel
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit lua/tabby/init.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 182 + 182) / 365)
exe 'vert 2resize ' . ((&columns * 182 + 182) / 365)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 36) / 73)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("lua/tabby/tabline.lua", ":p")) | buffer lua/tabby/tabline.lua | else | edit lua/tabby/tabline.lua | endif
if &buftype ==# 'terminal'
  silent file lua/tabby/tabline.lua
endif
balt lua/tabby/init.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 36) / 73)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 182 + 182) / 365)
exe 'vert 2resize ' . ((&columns * 182 + 182) / 365)
tabnext
edit lua/tabby/feature/buf_name.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 121 + 182) / 365)
exe 'vert 2resize ' . ((&columns * 121 + 182) / 365)
exe 'vert 3resize ' . ((&columns * 121 + 182) / 365)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 36) / 73)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("lua/tabby/feature/tab_name.lua", ":p")) | buffer lua/tabby/feature/tab_name.lua | else | edit lua/tabby/feature/tab_name.lua | endif
if &buftype ==# 'terminal'
  silent file lua/tabby/feature/tab_name.lua
endif
balt lua/tabby/feature/buf_name.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 30 - ((29 * winheight(0) + 36) / 73)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 30
normal! 029|
wincmd w
argglobal
if bufexists(fnamemodify("lua/tabby/feature/lines.lua", ":p")) | buffer lua/tabby/feature/lines.lua | else | edit lua/tabby/feature/lines.lua | endif
if &buftype ==# 'terminal'
  silent file lua/tabby/feature/lines.lua
endif
balt term://~/Projects/github.com/nanozuki/tabby.nvim//90617:/usr/local/bin/fish
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 36) / 73)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
exe 'vert 1resize ' . ((&columns * 121 + 182) / 365)
exe 'vert 2resize ' . ((&columns * 121 + 182) / 365)
exe 'vert 3resize ' . ((&columns * 121 + 182) / 365)
tabnext
argglobal
if bufexists(fnamemodify("term://~/Projects/github.com/nanozuki/tabby.nvim//90636:/usr/local/bin/fish", ":p")) | buffer term://~/Projects/github.com/nanozuki/tabby.nvim//90636:/usr/local/bin/fish | else | edit term://~/Projects/github.com/nanozuki/tabby.nvim//90636:/usr/local/bin/fish | endif
if &buftype ==# 'terminal'
  silent file term://~/Projects/github.com/nanozuki/tabby.nvim//90636:/usr/local/bin/fish
endif
balt term://~/Projects/github.com/nanozuki/tabby.nvim//90636:/usr/local/bin/fish
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 3 - ((2 * winheight(0) + 36) / 73)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 040|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
