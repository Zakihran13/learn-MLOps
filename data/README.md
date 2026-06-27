# Phase 1: Data Infrastructure & Automated Ingestion Quality (DataOps)

## Overview

Phase 1 establishes the **data foundation** for the MLOps system. This phase focuses on building a robust data pipeline with automatic validation, ensuring high-quality data reaches the training layer.

## Directory Structure

```
data/
├── db_utils.py              # Database connections & validators
├── scripts/
│   ├── generate_sample_data.py    # Synthetic data generator
│   ├── ingest_data.py            # Production ingestion script
│   └── validate_data.py          # Standalone validation module
└── raw/
    └── sample_data.jsonl         # Generated training data
```

## Tasks (1.1 - 1.5)

### Task 1.1: Database Schema & Connection Pool
**Objective:** Set up PostgreSQL with all required tables and implement connection pooling.

**Files to Complete:**
- `config/database_schema.sql` ✓ (Created)
- `data/db_utils.py` → Implement `DatabaseConnector` and `DatabaseConfig` classes

**Implementation Steps:**
1. Review `config/database_schema.sql` - understand all 6 tables and their relationships
2. Implement `DatabaseConfig.__init__()` - load credentials from env variables
3. Implement `DatabaseConnector.connect()` - create SQLAlchemy engine with pooling
4. Implement `DatabaseConnector.health_check()` - test connectivity
5. Implement `DatabaseConnector.get_connection()` - context manager for safe usage

**Success Criteria:**
- PostgreSQL container is running (check via `docker ps`)
- Connection pool works with 10+ concurrent connections
- Health check passes and logs "Database connections healthy"

---

### Task 1.2: Data Ingestion Pipeline
**Objective:** Implement automated data ingestion from files into raw_data table.

**Files to Complete:**
- `data/scripts/ingest_data.py` (Stub)
- `data/db_utils.py` → Use in ingestion

**Implementation Steps:**
1. Create `data/scripts/ingest_data.py` with:
   - `IngestionPipeline` class to read JSONL files
   - Parse JSON, extract features
   - Insert into `raw_data` table with timestamp and source
   - Handle duplicates and errors gracefully
   - Log ingestion metrics (rows inserted, errors, duration)

2. Implement CLI:
   ```bash
   python data/scripts/ingest_data.py --input data/raw/sample_data.jsonl --source api
   ```

**Success Criteria:**
- Can ingest 1000 sample records in <5 seconds
- Duplicate detection works
- Error logs are captured in `logs/ingestion.log`

---

### Task 1.3: Programmatic Data Validation
**Objective:** Implement validation checks before data reaches training.

**Files to Complete:**
- `config/validation_rules.yaml` ✓ (Created)
- `data/db_utils.py` → Implement `DataValidator` class
- `data/scripts/validate_data.py` (New stub)

**Implementation Steps:**
1. Complete `DataValidator` class in `db_utils.py`:
   - `validate_schema()` - check all required columns exist and match types
   - `validate_missing_values()` - alert if nulls exceed threshold
   - `detect_anomalies()` - z-score detection for outliers
   - `validate_all()` - orchestrate all checks

2. Create `data/scripts/validate_data.py`:
   - Read raw data from database
   - Run validation pipeline
   - Insert valid records into `validated_data` table
   - Log failures to `validation_failures` table
   - Generate validation report (# validated, # failed, # errors)

**Success Criteria:**
- All 1000 sample records pass validation
- Anomaly detection correctly flags obvious outliers
- Validation report saved to `logs/validation_report.json`

---

### Task 1.4: Data Splitting (Train/Val/Test)
**Objective:** Programmatically split validated data into train (60%), val (20%), test (20%).

**Files to Complete:**
- `data/scripts/split_data.py` (New stub)

**Implementation Steps:**
1. Create `data/scripts/split_data.py`:
   - Read from `validated_data` table
   - Stratified split to maintain label distribution
   - Insert into `train_split`, `val_split`, `test_split` tables
   - Tag with `split_version` (e.g., "v1.0") for reproducibility
   - Log statistics (counts, class distribution per split)

2. Implement stratification:
   - If binary classification: maintain positive/negative ratio in all splits
   - Use deterministic shuffling with seed=42

**Success Criteria:**
- Train split: ~600 records, val: ~200, test: ~200
- Class distribution preserved within 2% across all splits
- Split version enables reproducible results

---

### Task 1.5: Data Ingestion Monitoring & Alerts
**Objective:** Track ingestion health and alert on anomalies.

**Files to Complete:**
- `data/scripts/ingest_monitor.py` (New stub)

**Implementation Steps:**
1. Create `data/scripts/ingest_monitor.py` to:
   - Check row counts in `raw_data` by hour
   - Alert if new rows drop to zero (ingestion failed)
   - Alert if schema drift detected (new columns or missing columns)
   - Generate daily ingestion report

2. Integrate with monitoring:
   - Insert alerts into `monitoring_alerts` table
   - Save report to `logs/ingestion_monitor_report.json`

**Success Criteria:**
- Monitor detects ingestion halt within 1 hour
- Schema drift detection works for test case
- Daily reports generated at midnight UTC

---

## Running Phase 1

### Prerequisites
```bash
# Install Python dependencies
pip install -r training/requirements.txt  # Installs psycopg2, SQLAlchemy, etc

# Start database (if not running)
docker-compose -f docker/docker-compose.yaml up postgres pgadmin -d

# Wait for database to be ready
sleep 5
```

### Initialize Database
```bash
# Load schema into PostgreSQL
psql -h localhost -U postgres -f config/database_schema.sql

# Or via docker:
docker exec mlops-postgres psql -U postgres -f /config/database_schema.sql
```

### Generate Sample Data
```bash
python data/scripts/generate_sample_data.py \
    --n_samples 1000 \
    --output data/raw/sample_data.jsonl \
    --positive_ratio 0.5
```

### Execute Pipeline
```bash
# Ingest
python data/scripts/ingest_data.py --input data/raw/sample_data.jsonl --source api

# Validate
python data/scripts/validate_data.py

# Split
python data/scripts/split_data.py --split_version v1.0

# Monitor
python data/scripts/ingest_monitor.py --report_type daily
```

### Verify Results
```bash
# Check database
psql -h localhost -U postgres -d mlops -c \
    "SELECT COUNT(*) FROM raw_data; SELECT COUNT(*) FROM validated_data; SELECT COUNT(*) FROM train_split;"

# Check logs
cat logs/ingestion.log
cat logs/validation_report.json
cat logs/split_report.json
```

---

## Key Concepts Introduced

1. **Connection Pooling**: Efficient database resource management for high-concurrency scenarios
2. **JSONL Format**: Line-delimited JSON for streaming data ingestion
3. **Schema Validation**: Programmatic data quality checks before processing
4. **Stratified Splitting**: Maintaining data distribution across splits (critical for ML)
5. **Lineage Tracking**: Every piece of data traced back to source (raw → validated → split)

---

## Common Issues & Troubleshooting

| Issue | Solution |
|-------|----------|
| `psycopg2.OperationalError: could not connect` | Check PostgreSQL container is running: `docker ps` |
| `Column 'X' does not exist` | Verify database_schema.sql was loaded: `psql -h localhost -U postgres -d mlops -c "\dt"` |
| `Validation failing on all records` | Check validation_rules.yaml thresholds - might be too strict for test data |
| `Split counts don't match expected` | Verify no records were filtered by validation; check logs |

---

## Acceptance Checklist

- [ ] PostgreSQL connection pool tested with 10+ concurrent requests
- [ ] All 1000 sample records ingested successfully
- [ ] Validation pipeline passes 100% of records (for clean data)
- [ ] Train/Val/Test splits have correct counts and class distribution
- [ ] All logs written to `logs/` directory
- [ ] Database audit logs show all ingestion events
- [ ] Monitoring detects and alerts on simulated issues

---

## Next Phase
Once Phase 1 completes, proceed to **Phase 2: Continuous Training Infrastructure & MLflow Automation**.

The trained data splits from this phase feed directly into Phase 2's training pipeline.
