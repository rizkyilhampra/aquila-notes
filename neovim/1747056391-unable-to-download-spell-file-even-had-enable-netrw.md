---
id: 1747056498-unable-to-download-spell-file-even-had-enable-netrw
aliases:
  - Unable to download spell file even had enable netrw
tags:
  - neovim
  - spell
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