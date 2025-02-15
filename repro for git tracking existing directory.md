---
id: repro for git tracking existing directory
aliases: []
tags: []
---

```bash
git init
git config --local user.name rizkyilhampra
git config --local user.email "rizkyilhampra@gmail.com"
git remote add origin git@github.com:it-rspi/mlite.git
git fetch origin prod
git checkout -b prod origin/prod
```
