if exists('current_compiler')
  finish
endif
let current_compiler = 'p'

" abs --pproj for :make from any cwd
let s:proj = p#ProjectFile(expand('%:p'))
let s:exe = shellescape(p#Executable())

if empty(s:proj)
  let &l:makeprg = s:exe . ' compile'
else
  let &l:makeprg = s:exe . ' compile --pproj ' . shellescape(s:proj)
        \ . ' --outdir ' . shellescape(fnamemodify(s:proj, ':h'))
endif

CompilerSet errorformat=[Error:]\ [%f:%l:%c]\ %m,[Parser\ Error:]\ [%f]\ parse\ error:\ line\ %l:%c\ %m,%-G%.%#
