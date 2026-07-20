---
id: 1784530432-bench-sh-vps-benchmark-script
aliases: [bench.sh, Teddysun Benchmark]
tags: [vps, cheatsheets]
publish: false
created: 2026-07-20 14:53
modified: 2026-07-20 14:53
title: bench.sh (Teddysun VPS Benchmark)
---

# bench.sh (Teddysun VPS Benchmark)

A long-standing VPS benchmark script by Teddysun. Run it with:

```bash
curl -Lso- bench.sh | bash
```

## What it tests
- Basic system info (CPU, memory, uptime, OS)
- A simple disk I/O test
- Multi-location network speed test

## Flag breakdown
- `-L` — follow redirects
- `-s` — silent; suppress the progress meter
- `-o-` — write the downloaded script to stdout (instead of a file), which is then piped to `bash`

> [!NOTE]
> Same pipe-to-bash caveat as YABS — download and review before running as root: `curl -Lso bench.sh bench.sh`, `less bench.sh`, then `bash bench.sh`.


