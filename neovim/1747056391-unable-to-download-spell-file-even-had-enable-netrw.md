---
id: 1747056498-unable-to-download-spell-file-even-had-enable-netrw
aliases:
  - Unable to download spell file even had enable netrw
tags:
  - neovim
  - workaround
---
# Unable to download spell file even had enable netrw

On this note [[neovim/1728601004-indonesian-spell-check-neovim|Indonesian Spell Check Neovim]] at Note section, maybe there are still facing issue like unable to download automatically the spell file. The workaround for this is run the neovim with `--clean` flag, then do following this neovim commands by pressing `:`

```
set spell
```

```
set spelllang=en,id
```

> If `id` is the spell you want to use or download  

---
Source: https://www.reddit.com/r/neovim/comments/yi6e4a/comment/iuhlvwt/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button