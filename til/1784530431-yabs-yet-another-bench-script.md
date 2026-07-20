---
id: 1784530431-yabs-yet-another-bench-script
aliases: [YABS, Yet Another Bench Script]
tags: [vps, cheatsheets]
publish: false
created: 2026-07-20 14:53
modified: 2026-07-20 14:53
title: YABS (Yet Another Bench Script)
---

# YABS (Yet Another Bench Script)

A popular VPS benchmarking script by Mason Rowe. Run it with:

```bash
curl -sL yabs.sh | bash
```

## What it tests
- CPU performance (single- and multi-threaded)
- Disk I/O via `dd` and `fio`
- Network throughput via `iperf3` to multiple locations
- Geekbench score (when the Geekbench binary is reachable)

## Flag breakdown
- `-s` — silent; suppress curl's progress meter so only the script output shows
- `-L` — follow redirects (yabs.sh redirects to the raw script on GitHub)
- `| bash` — pipe the downloaded script straight into the shell

> [!NOTE]
> Both commands execute remote code, typically as root. To inspect before running: download with `curl -sL yabs.sh -o yabs.sh`, review it with `less yabs.sh`, then run `bash yabs.sh`.


