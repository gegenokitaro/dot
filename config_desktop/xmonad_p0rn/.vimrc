set number
execute pathogen#infect()
set t_Co=256
set laststatus=2
set mouse=a
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>
highlight LineNr ctermfg=grey ctermbg=black
set cursorline
hi clear cursorline
highlight CursorLineNr ctermfg=yellow ctermbg=black
