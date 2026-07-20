---
id: 1784530432-bench-sh-vps-benchmark-script
aliases:
  - bench.sh
  - Teddysun Benchmark
tags:
  - vps
  - devops
  - cheatsheets
publish: true
created: 2026-07-20 14:53
modified: 2026-07-20 15:20
title: bench.sh (Teddysun VPS Benchmark)
---

# bench.sh (Teddysun VPS Benchmark)

bench.sh is a long-standing VPS benchmark script by Teddysun. Run it with:

```bash
curl -Lso- bench.sh | bash
```

It prints basic system info (CPU, memory, uptime, OS), runs a simple disk I/O test, and speed-tests the network against multiple global locations. 

Source: [Github](https://github.com/teddysun/across/blob/master/bench.sh), [Web](https://bench.sh/en.html)