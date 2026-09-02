" filetype.vim claims '*.p' already for Progress; setf is a no-op here
autocmd BufRead,BufNewFile *.p setlocal filetype=p
autocmd BufRead,BufNewFile *.pproj setlocal filetype=xml
