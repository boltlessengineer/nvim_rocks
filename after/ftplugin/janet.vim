" mostly copied from https://github.com/janet-lang/janet.vim/blob/67075b190a44310df356137e35cc1949782b20e0/ftplugin/janet.vim

setlocal comments=n:#
setlocal commentstring=#\ %s
setlocal define=\\v[(/]def(ault)@!\\S*
setlocal formatoptions-=t
setlocal lisp
setlocal tabstop=2

" HACK: dirty hack to make :ParinferToggle work on every state
let b:parinfer_enabled=1
nnoremap <buffer> <cr> <cmd>ParinferToggle<cr>
