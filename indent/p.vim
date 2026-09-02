if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" no : in cinkeys. ends a test dec as well as a recv case label
setlocal cindent
setlocal cinoptions=:0,l1,g0,(0,Ws,j1,J1
setlocal cinkeys=0{,0},0),0],!^F,o,O

let b:undo_indent = 'setlocal cindent< cinoptions< cinkeys<'
