setlocal spelllang=en_us

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.rdoc setlocal spell
autocmd BufRead,BufNewFile *.markdown setlocal spell
autocmd FileType gitcommit setlocal spell
