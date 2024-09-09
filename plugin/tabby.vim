"" TODO
function! TabbyCustomClickHandler(minwid, clicks, btn, modifiers) abort
    call luaeval(
        \ "require'tabby.module.node'.handle_custom_click(_A[1], _A[2], _A[3], _A[4])",
        \ [a:minwid, a:clicks, a:btn, a:modifiers]
        \)
endfunction

function! TabbyOpenBuffer(minwid, clicks, btn, modifiers) abort
    " Run the following code only on a single left mouse button click without modifiers pressed
    if a:clicks == 1 && a:btn is# 'l' && a:modifiers !~# '[^ ]'
        execute 'buffer' a:minwid
    endif
endfunction

function! TabbyTabline() abort
    return luaeval("require'tabby'.update()")
endfunction

function! TabbyRenderTabline() abort
    return luaeval("require'tabby.tabline'.render()")
endfunction
