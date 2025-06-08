---
id: 1748684577-create-file-with-timestamp
aliases:
  - Create file with timestamp
tags: []
---

# Create file with timestamp

## Migration File Example

```bash
touch migrations/$(date +"%Y%m%d%H%M%S")_create_table_pilot_discharge_planning_obat_pulang.sql
```
