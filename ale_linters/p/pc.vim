" opt-in to linting
if !get(g:, 'p_lint', 0)
  finish
endif

call ale#Set('p_pc_executable', p#Executable())
call ale#Set('p_pc_options', '')

function! s:BufferPath(buffer) abort
  return ale#path#Simplify(fnamemodify(bufname(a:buffer), ':p'))
endfunction

function! s:FindProject(buffer) abort
  return p#ProjectFile(s:BufferPath(a:buffer))
endfunction

function! ale_linters#p#pc#GetCwd(buffer) abort
  let l:project = s:FindProject(a:buffer)
  return empty(l:project)
        \ ? fnamemodify(s:BufferPath(a:buffer), ':h')
        \ : fnamemodify(l:project, ':h')
endfunction

" keep 'PGenerated/' out of cwd
function! s:OutDir(key) abort
  return ale#path#Simplify(
        \ fnamemodify(tempname(), ':h') . '/p-vim-' . sha256(a:key)[:15]
        \)
endfunction

" use buffer contents for checking w/out save
function! ale_linters#p#pc#GetCommand(buffer) abort
  let l:project = s:FindProject(a:buffer)
  let l:options = ale#Var(a:buffer, 'p_pc_options')
  let l:self = s:BufferPath(a:buffer)

  if empty(l:project)
    let l:files = []
    let l:name = fnamemodify(l:self, ':t:r')
    let l:out = s:OutDir(l:self)
  else
    let l:files = filter(p#ProjectFiles(l:project),
          \ 'ale#path#Simplify(v:val) isnot# l:self')
    let l:name = fnamemodify(l:project, ':t:r')
    let l:out = s:OutDir(l:project)
  endif

  return '%e compile --pfiles %t '
        \ . join(map(l:files, 'ale#Escape(v:val)'), ' ')
        \ . ' --projname ' . ale#Escape(substitute(l:name, '[^A-Za-z0-9_]', '_', 'g'))
        \ . ' --outdir ' . ale#Escape(l:out)
        \ . (empty(l:options) ? '' : ' ' . l:options)
endfunction

function! s:Resolve(root, loaded, name) abort
  let l:abs = ale#path#GetAbsPath(a:root, a:name)

  return filereadable(l:abs)
        \ ? l:abs
        \ : get(a:loaded, fnamemodify(a:name, ':t'), l:abs)
endfunction

function! ale_linters#p#pc#Handle(buffer, lines) abort
  let l:root = ale_linters#p#pc#GetCwd(a:buffer)
  " type errs path is relative to cwd, parse errs are only a basename
  let l:project = s:FindProject(a:buffer)
  let l:loaded = {}
  for l:file in empty(l:project) ? [] : p#ProjectFiles(l:project)
    let l:loaded[fnamemodify(l:file, ':t')] = l:file
  endfor
  let l:loaded[fnamemodify(s:BufferPath(a:buffer), ':t')] = s:BufferPath(a:buffer)
  let l:located = '\v^\[%(Error|NotSupportedError|NotImplementedError):\]\s*'
        \ . '\[(.{-}):(\d+):(\d+)\]\s*(.*)$'
  let l:parse = '\v^\[Parser Error:\]\s*\[(.{-})\]\s*'
        \ . 'parse error:\s*line (\d+):(\d+)\s*(.*)$'
  let l:gated = '\v^\[\a+Error:\]\s*(.{-})\s*\(line (\d+):(\d+)\):\s*(.*)$'
  let l:output = []
  let l:unlocated = []
  for l:line in a:lines
    " antlr counts columns from 0. type checker from 1.
    let l:coloff = 0
    let l:match = matchlist(l:line, l:located)
    if empty(l:match)
      let l:match = matchlist(l:line, l:parse)
      let l:coloff = 1
    endif
    if empty(l:match)
      let l:match = matchlist(l:line, l:gated)
      let l:coloff = 1
    endif
    if !empty(l:match)
      call add(l:output, {
            \ 'filename': s:Resolve(l:root, l:loaded, l:match[1]),
            \ 'lnum': str2nr(l:match[2]),
            \ 'col': str2nr(l:match[3]) + l:coloff,
            \ 'text': l:match[4],
            \ 'type': 'E',
            \})
    elseif l:line =~# '\v^\[\a*\s*Error:\]'
      call add(l:unlocated, {
            \ 'lnum': 1,
            \ 'text': substitute(l:line, '\v^\[[^]]*\]\s*', '', ''),
            \ 'type': 'E',
            \})
    endif
  endfor
  if !empty(l:output)
    return l:output
  endif
  if !empty(l:unlocated)
    return l:unlocated
  endif

  " no 'type checking' line means p failed to run
  if match(a:lines, 'Type checking') < 0
    let l:said = filter(copy(a:lines), '!empty(trim(v:val))')
    return [{
          \ 'lnum': 1,
          \ 'type': 'E',
          \ 'text': 'p compile failed to run: ' . get(l:said, 0, '(no output)'),
          \}]
  endif

  return []
endfunction

call ale#linter#Define('p', {
      \ 'name': 'pc',
      \ 'aliases': ['p'],
      \ 'executable': {b -> ale#Var(b, 'p_pc_executable')},
      \ 'cwd': function('ale_linters#p#pc#GetCwd'),
      \ 'command': function('ale_linters#p#pc#GetCommand'),
      \ 'callback': 'ale_linters#p#pc#Handle',
      \ 'output_stream': 'both',
      \})
