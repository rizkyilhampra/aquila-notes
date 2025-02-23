---
id: Remove Executable Flag from Conflicted Files in Git
aliases: []
tags: []
---

This command chain removes the executable permission flag from files that are currently in a merge conflict state in a Git repository.

```bash
git ls-files -u | awk -F' ' '{print substr($0, index($0, $4))}' | xargs -d '\n' git update-index --chmod=-x
```

1. `git ls-files -u`
    - Lists all unmerged (conflicted) files in the Git repository
    - The -u flag specifically shows the conflicted files
2. `awk -F' ' '{print substr($0, index($0, $4))}'`
	- Processes the output to extract just the filenames
	- Removes the mode/SHA prefix that Git includes in the output
3. `xargs -d '\n' git update-index --chmod=-x`
	- Takes the filtered filenames and removes their executable flag
	- The `-d '\n'` tells `xargs` to use newlines as delimiters `--chmod=-x` removes the executable permission