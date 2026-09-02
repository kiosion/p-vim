" Language: P (github.com/p-org/P)
" Keywords taken from PLexer.g4

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match

syn keyword pType any bool int float string data map set seq
syn keyword pType machine event nextgroup=pDeclName skipwhite

syn keyword pStructure enum eventset interface spec scenario type module
      \ implementation test paramtest invariant Proof Lemma Theorem
      \ nextgroup=pDeclName skipwhite
syn keyword pStructure state nextgroup=pDeclName skipwhite
syn keyword pStructure fun pure nextgroup=pFunName skipwhite
syn keyword pStructure axiom

syn keyword pStorageClass var param start hot cold safe main

syn keyword pConditional if else
syn keyword pRepeat while foreach

syn keyword pStatement announce assert assume break continue print raise
      \ receive return send
syn keyword pStatement goto nextgroup=pDeclName skipwhite

syn keyword pKeyword as to in with do on entry exit defer ignore observes
      \ receives sends creates refines case pairwise wise
syn keyword pKeyword is inflight targets sent prove using except requires
      \ ensures forall exists
syn match   pKeyword "\<init-condition\>"

syn keyword pModuleOp compose union hidee hidei rename

syn keyword pBuiltin new choose keys values sizeof format default

syn keyword pBoolean true false
syn keyword pConstant null halt this

syn match pDeclName "\<\h\w*\>" contained
syn match pFunName  "\<\h\w*\>" contained

" syn keyword outranks syn match; 'if(' & 'format(' keep own groups
syn match pFunCall "\<\h\w*\ze\s*("

syn match pNumber "\<\d\+\>"
syn match pFloat  "\<\d\+\.\d\+\>"

syn match  pEscape "\\." contained
syn match  pFormatSpec "{\d\+}" contained
syn region pString start=+"+ skip=+\\.+ end=+"+ contains=pEscape,pFormatSpec

syn match pNondet "\$\$\?"

syn match pOperator "<==>\|==>\|&&\|||\|==\|!=\|<=\|>=\|->\|+=\|-=\|[-+*/%<>=!]"

" after pOperator to let '//' beat a bare '/' at the same pos
syn keyword pTodo contained TODO FIXME XXX NOTE HACK
syn region  pComment start="/\*" end="\*/" contains=pTodo,@Spell
syn match   pComment "//.*$" contains=pTodo,@Spell

if get(g:, 'p_syntax_folding', 0)
  syn region pBlock start="{" end="}" transparent fold
endif

syn sync fromstart

hi def link pType         Type
hi def link pStructure    Structure
hi def link pStorageClass StorageClass
hi def link pConditional  Conditional
hi def link pRepeat       Repeat
hi def link pStatement    Statement
hi def link pKeyword      Keyword
hi def link pModuleOp     Keyword
hi def link pBuiltin      Function
hi def link pBoolean      Boolean
hi def link pConstant     Constant
hi def link pDeclName     Identifier
hi def link pFunName      Function
hi def link pFunCall      Function
hi def link pNumber       Number
hi def link pFloat        Float
hi def link pString       String
hi def link pEscape       SpecialChar
hi def link pFormatSpec   SpecialChar
hi def link pNondet       Special
hi def link pOperator     Operator
hi def link pComment      Comment
hi def link pTodo         Todo

let b:current_syntax = 'p'

let &cpo = s:cpo_save
unlet s:cpo_save
