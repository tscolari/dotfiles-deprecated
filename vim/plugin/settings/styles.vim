"colorscheme zenburn
colorscheme lettuce

if has("gui_running")
  "tell the term has 256 colors
  set t_Co=256

  " Show tab number
  " For some reason this doesn't work as a regular set command,
  " (the numbers don't show up) so I made it a VimEnter event
  autocmd VimEnter * set guitablabel=%N:\ %t\ %M

  set lines=60
  set columns=190

  set guifont=Bitstream\ Vera\ Sans\ Mono:h14
else
  "dont load csapprox if we no gui support - silences an annoying warning
  let g:CSApprox_loaded = 1
endif
