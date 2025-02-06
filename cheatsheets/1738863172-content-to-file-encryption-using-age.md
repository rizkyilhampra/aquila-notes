---
id: 1738863172-content-to-file-encryption-using-age
aliases:
  - Content to File Encryption using Age
tags:
  - cheatsheets
  - age
  - encryption/decryption
  - file
  - security
---

# Content to File Encryption using Age

```bash
echo "Hello world" | age -i /path/to/key.txt -e -o /path/to/file.age
```
