# Project structure

```text
GreenTrail_SQL_GitHub_Ready/
├── README.md
├── .gitignore
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables_mysql.sql
│   ├── 03_import_data_mysql.sql
│   ├── 04_data_exploration.sql
│   └── 05_data_quality_checks.sql
├── data/
│   ├── samples/                 # small CSV previews, tracked on GitHub
│   ├── generation_script.py     # reproducible synthetic data generator
│   └── source/                 # local original materials, gitignored
└── docs/
    ├── data_dictionary.csv
    └── PROJECT_STRUCTURE.md
```

**Note:** Full synthetic CSVs and the SQLite export remain available in the separate expanded dataset ZIP. They are intentionally excluded here to keep the GitHub repository manageable. The import script expects full data and uses an absolute Windows MySQL path; review that path before running.

**Suggested repository name:** `greentrail-retail-sql-analysis`
