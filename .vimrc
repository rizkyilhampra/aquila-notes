inoremap jj <Esc>

" The keys j and k for visual and normal mode go to the visual line instead of the logical one (Really useful for a more organic experience)
noremap j gj
noremap k gk

" Uses H and L To navigate between blank lines in Visual and Normal modes.
noremap H {
noremap L }

" Uses K and J to scroll back and forth in Visual and Normal modes
noremap K <C-b>
noremap J <C-f>

" Uses ; to start commands in Visual and Normal modes
noremap ; :
