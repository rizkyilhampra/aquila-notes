---
publish: true
id: 1732264756-how-to-combine-two-repository-with-unrelated-history
aliases:
  - How to combine two repository with unrelated history and keep upcoming changes
tags: []
title: How to combine two repository with unrelated history and keep upcoming changes
created: 2024-11-22 16:44
modified: 2025-11-17 01:38
---

# How to combine two repository with unrelated history and keep upcoming changes

Do this in the repository that will receive the changes from the other repository.

```bash
git merge --squash --allow-unrelated-histories -X theirs branch-name
```
