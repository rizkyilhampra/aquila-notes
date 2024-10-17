---
id: 1728601004-indonesian-spell-check-neovim
aliases:
  - Indonesian Spell Check Neovim
tags: []
---

# Indonesian Spell Check [[1728601745-neovim|Neovim]]

*Spell checker* di [[1728601745-neovim|Neovim]] dapat kita konfigurasi dengan mendefinisikan *option* berikut:

```lua
vim.opt.spell = true
```

Secara *default* bahasa yang akan di cek adalah Bahasa Inggris. Untuk menambahkan Bahasa Indonesia kita bisa menambahkan nya dengan *option* berikut:

```lua
vim.opt.spelllang:append("id");
```

atau jika ingin spesifik

```lua
vim.opt.spellang = "en,id"
```

Setelah itu Bahasa Indonesia akan ter-*download* otomatis (jika tidak ada), namun sebelumnya kita akan mendapatkan *prompt* dari [[1728601745-neovim|Neovim]] untuk mengonfirmasi untuk men-*donwload*.

> [!NOTE]
> Di suatu kasus kemungkinan *prompt* tidak akan tampil dan Bahasa Indonesia tidak akan ter-*download* secara otomatis. Maka pastikan untuk tidak menonaktifkan `netrw`. Berikut adalah contoh menghapus `netrw` dari daftar *rtp plugin* yang dinonaktifkan di `lazy.nvim`  
> 
> ```diff
> require("lazy").setup(
> 	{},
> 	{
> 		performance = {
> 			rtp =  {
> 				disabled_plugins = {
> -                 "netrwPlugin"
> 				}
> 			}
> 		}
> 	}
> )
> ```
