"" TODO
function! TabbyCustomClickHandler(minwid, clicks, btn, modifiers) abort
    call luaeval(
        \ "require'tabby.module.node'.handle_custom_click(_A[1], _A[2], _A[3], _A[4])",
        \ [a:minwid, a:clicks, a:btn, a:modifiers]
        \)
endfunction

function! TabbyTabline() abort
    return luaeval("require'tabby'.update()")
endfunction

function! TabbyRenderTabline() abort
    return luaeval("require'tabby.tabline'.render()")
endfunction
