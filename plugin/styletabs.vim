function! StyletabsBufClickHandler(minwid, clicks, btn, modifiers) abort
    call luaeval(
        \ "require'styletabs'.handle_buf_click(_A[1], _A[2], _A[3], _A[4])",
        \ [a:minwid, a:clicks, a:btn, a:modifiers]
        \)
endfunction

function! StyletabsRender() abort
    return luaeval("require'styletabs'.update()")
endfunction
