" Does not work on pending 'blocks', only single lines
"
" Given:
" it "foo bar" do
"   pending("bla bla"
"
" Produce:
" xit "foo bar" do
"
function! ChangePendingRspecToXit()
  " Find the next occurrence of pending
  while(search("pending(") > 0)
    " Delete it
    normal dd
    " Search backwards to the it block
    ?it\s
    " add an 'x' to the 'it' to make it 'xit'
    normal ix
  endwhile
endfunction

nnoremap <silent> ,rxit :call ChangePendingRspecToXit()<cr>

" insert a before { } block around a line
nnoremap <silent> \bf ^ibefore { <esc>$a }

" ============================
" vim-ruby-conque
" ============================
" ,r to run the current file
nmap <silent> ,r <Plug>SendTestToTmux
" ,R to run the current line
nmap <silent> ,R <Plug>SendFocusedTestToTmux

" Rspec.vim mappings
" map <Leader>R  :call RunCurrentSpecFile()<CR>
" map <Leader>rr :call RunNearestSpec()<CR>
" map <Leader>rl :call RunLastSpec()<CR>
" map <Leader>ra :call RunAllSpecs()<CR>
" 
" let g:rspec_command = "Dispatch rspec {spec}"
