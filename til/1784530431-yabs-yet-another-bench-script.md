---
id: 1784530431-yabs-yet-another-bench-script
aliases:
  - YABS
  - Yet Another Bench Script
tags:
  - vps
  - cheatsheets
publish: true
created: 2026-07-20 14:53
modified: 2026-07-20 14:53
title: YABS (Yet Another Bench Script)
---

# YABS (Yet Another Bench Script)

YABS (Yet Another Bench Script), written by Mason Rowe, is a popular one-liner for benchmarking a freshly provisioned VPS. Run it with:

```bash
curl -sL yabs.sh | bash
```

It measures CPU performance (both single- and multi-threaded), disk I/O through `dd` and `fio`, network throughput via `iperf3` to several locations, and a Geekbench score when the binary is reachable. 