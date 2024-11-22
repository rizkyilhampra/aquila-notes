---
id: 1732264756-how-to-combine-two-repository-with-unrelated-history
aliases:
  - How to combine two repository with unrelated history and keep upcoming changes
tags: []
---

# How to combine two repository with unrelated history and keep upcoming changes

Do this in the repository that will receive the changes from the other repository.

```bash
git merge --squash --allow-unrelated-histories -X theirs branch-name
```
