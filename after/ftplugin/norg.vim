setlocal breakindent
setlocal formatoptions-=r
setlocal linebreak
setlocal shiftwidth=1
setlocal wrap

function! ToggleConcealLevel()
  if &conceallevel > 0
    set conceallevel=0
  else
    set conceallevel=3
  endif
endfunction

nnoremap <CR> <cmd>call ToggleConcealLevel()<CR>
