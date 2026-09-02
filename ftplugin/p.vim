if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s
setlocal formatoptions-=t formatoptions+=croql
setlocal suffixesadd=.p
setlocal shiftwidth=2 softtabstop=2 expandtab

if !exists('b:current_compiler')
  compiler p
endif

let b:undo_ftplugin = 'setlocal comments< commentstring< formatoptions<'
      \ . ' suffixesadd< shiftwidth< softtabstop< expandtab<'
      \ . ' makeprg< errorformat< | unlet! b:current_compiler'

let &cpo = s:cpo_save
unlet s:cpo_save
