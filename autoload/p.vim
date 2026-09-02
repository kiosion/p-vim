" dotnet's global tools, checked first
function! p#Executable() abort
  let l:tool = expand('~/.dotnet/tools/p')
  if executable(l:tool)
    return l:tool
  endif
  return 'p'
endfunction

" abs paths of every .p a *.pproj includes
function! p#ProjectFiles(proj) abort
  let l:dir = fnamemodify(a:proj, ':h')
  let l:files = []
  for l:line in readfile(a:proj)
    let l:entry = matchstr(l:line, '\v\<PFile\>\s*\zs[^<]{-}\ze\s*\</PFile\>')
    if empty(l:entry)
      continue
    endif
    let l:path = l:entry[0] ==# '/' ? l:entry : simplify(l:dir . '/' . l:entry)
    call extend(l:files,
          \ isdirectory(l:path) ? glob(l:path . '/**/*.p', 1, 1) : [l:path])
  endfor
  return map(l:files, 'fnamemodify(v:val, ":p")')
endfunction

" nearest *.pproj at or above path
function! p#ProjectFile(path) abort
  let l:dir = fnamemodify(a:path, ':p:h')

  while 1
    let l:found = glob(l:dir . '/*.pproj', 1, 1)
    if !empty(l:found)
      return l:found[0]
    endif

    let l:parent = fnamemodify(l:dir, ':h')
    if l:parent ==# l:dir
      return ''
    endif

    let l:dir = l:parent
  endwhile
endfunction
