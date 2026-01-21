---
id: 1768967611-how-beszel-data-works
aliases:
  - How Beszel data works
tags: []
publish: false
created:
modified:
---
# How Beszel data works
Data is stored in PocketBase (SQLite) at `./beszel_data/`:
- `system_stats` collection - system metrics
- `container_stats` collection - container metrics

Aggregation chain (runs every 10 minutes via cron):
1m records -> 10m -> 20m -> 120m -> 480m -> 1d (new)