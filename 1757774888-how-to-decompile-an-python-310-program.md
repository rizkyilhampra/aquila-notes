---
id: 1757774948-how-to-decompile-an-python-310-program
alias: How to decompile an python 3.10 program
tags: []
date: 2025-09-13 22:49:00 +0800
---
# How to decompile an python 3.10 program

Saya mulai ini dari di tempat saya bekerja, saya butuh mendapatkan bagaimana caranya suatu aplikasi dengan ektensi .exe bekerja. Ya, dengan meminta bantuan langsung atau menghubungi pihak yang berkaitan langsung dengan aplikasi tersebut untuk mempertanyakan pertanyaan demikian nampaknya sangat mudah, namun saya rasa tidak. Itu mungkin membutuhkan waktu yang lama dan kemungkinan untuk mendapatkan dokumentasinya bisa di angka 50%, terlebih belum dengan tetek bengek lainnya yang akan makan waktu dan tenaga juga. Maka dari itu saya berangkat dari "Bagaimana jika kita reverse engineering aplikasi ini?" munculah ide untuk mencari-cari informasi (basically this is just chatting with gpt-5 model tho) dan setelah beberapa *trial and error* saya berhasil untuk *decompile basically an python program but it's like compile to an windows program (.exe)*. Berikut adalah tulisan atau panduan atau mungkin *step by step* bagaimana saya melakukannya di Arch Linux.
## Requirements
*Needs to install*
- `uv`
- `libxcrypt-compat`

## How to 
1. Install python 3.10.0 with uv command

```
uv python install 3.10.0
```

2.  Create an self python 3.10.0 environment  

```
uv venv -p 3.10.0 .venv3100
```

3. Activate the environment or source it

```bash
source .venv3100/bin/activate.fish
```

4.  Ensure it's python 3.10.0

```bash
python -V
```

5. Install or upgrade pip in that environment

```bash
python -m ensurepip --upgrade
```

6. Install or upgrade toolchain

```bash
python -m pip install -U pip wheel setuptools
```

7. Install or upgrade the `pyinstxtractor-ng` 

```bash
python -m pip install -U pyinstxtractor-ng
````

8. Extract the `.exe`

```bash
pyinstxtractor-ng program-name.exe
```

9. Check the extracted folder

```bash
ls program-name.exe_extracted/
```

10. Extract the PYZ ones if it's have

```bash
pyinstxtractor-ng program-name.exe_extracted/PYZ-00.pyz
```

11. Install `pycdc` patched by me 
> Cause the main pycdc it's have limitation, i need li