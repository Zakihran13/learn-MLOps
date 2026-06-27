# MLOps Learning Module: Setup & Installation Guide

**Step-by-step environment and infrastructure setup**

---

## 📋 Prerequisites

- Python 3.8+ (or 3.10+)
- Docker & Docker Compose
- Git
- PostgreSQL client tools (psql)
- ~10GB disk space for images and databases
- ~2GB RAM available for Docker services

---

## 🚀 Step 1: Clone & Environment Setup

```bash
# Navigate to repo
cd C:\Users\zakis\OneDrive\Desktop\learn-MLOps

# Create Python virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Linux/Mac:
source venv/bin/activate

# Verify activation (should show (venv) in terminal)
python --version  # Should show 3.8+
```

---

## 🐳 Step 2: Docker Stack Setup

```bash
# Navigate to docker directory
cd docker

# Build and start Docker stack (PostgreSQL + MLflow + optional services)
docker-compose up -d

# Verify services are running
docker-compose ps

# Output should show:
# - PostgreSQL (port 5432)
# - pgAdmin (port 5050) - admin UI for database
# - MLflow Server (port 5000) - experiments tracking
```

### Access Docker Services

- **PostgreSQL:** `localhost:5432` (user: postgres, password: postgres)
- **pgAdmin:** http://localhost:5050 (user: admin@admin.com, password: admin)
- **MLflow:** http://localhost:5000 (experiments tracking UI)

---

## 🗄️ Step 3: Database Schema Initialization

```bash
# From repo root directory
# Option 1: Using psql directly
psql -U postgres -h localhost -d postgres < config/database_schema.sql

# Option 2: Using Python script (if available)
python scripts/init_database.py

# Verify schema created
psql -U postgres -h localhost -d mlops -c "\dt"

# Should show tables:
# - raw_data
# - validated_data
# - train_split, val_split, test_split
# - inference_logs
# - monitoring_alerts
# - audit_logs
```

---

## 📦 Step 4: Install Python Dependencies

```bash
# Install data layer dependencies
pip install -r data/requirements.txt

# Install training dependencies
pip install -r training/requirements.txt

# Install serving dependencies
pip install -r serving/requirements.txt

# Install testing dependencies
pip install pytest pytest-cov pytest-asyncio

# Verify installations
pip list | grep -E "mlflow|pyspark|fastapi|transformers|torch|psycopg2"
```

---

## ✅ Step 5: Verification

### Test PostgreSQL Connection

```bash
python scripts/test_db_connection.py

# Expected output:
# ✓ PostgreSQL connection successful
# ✓ Tables found: 7
```

### Test MLflow Connection

```bash
curl http://localhost:5000/api/2.0/mlflow/experiments/list

# Expected output:
# JSON with experiments list (may be empty initially)
```

### Test Data Ingestion (Phase 1)

```bash
python data/scripts/ingest_pipeline.py --sample-size 100

# Expected output:
# Rows ingested: 100
# Validation checks passed: 95
# Failed validation: 5
```

---

## 📂 Configuration Files

### Training Config (`config/training_config.yaml`)

```yaml
# Model hyperparameters
model:
  model_name: "distilbert-base-uncased"
  num_labels: 2
  max_seq_length: 128
  
training:
  learning_rate: 2e-5
  batch_size: 32
  num_epochs: 3
  warmup_steps: 500
  
reproducibility:
  seed: 42
```

### Promotion Rules (`config/promotion_rules.yaml`)

```yaml
# Rules for automatic model promotion
comparison:
  f1_threshold: 0.85
  f1_delta_min_improvement: -0.02  # Allow 2% drop max
  latency_threshold_ms: 100
  
validation:
  min_passing_tests: 5  # All tests must pass
  min_validation_samples: 100
```

### Validation Rules (`config/validation_rules.yaml`)

```yaml
# Data validation thresholds
validation_checks:
  schema_strict: true
  missing_value_threshold: 0.10  # Alert if > 10%
  anomaly_threshold_sigma: 3.0
  cardinality_change_threshold: 0.05
```

### Alert Rules (`config/alert_rules.yaml`)

```yaml
# Drift and alert thresholds
drift_detection:
  ks_test_threshold: 0.05
  psi_threshold: 0.1
  check_frequency: "hourly"  # or "every_n_inferences"
  n_inferences: 100
```

---

## 🧪 Quick Sanity Checks

### 1. Database Tables
```bash
# Connect to PostgreSQL
psql -U postgres -h localhost -d mlops

# Inside psql:
\dt                          # List all tables
SELECT COUNT(*) FROM raw_data;  # Check if empty
\q                           # Exit
```

### 2. MLflow Server
```bash
# Check MLflow is running
curl -s http://localhost:5000/api/2.0/tracking/get-experiment\?experiment_id\=0

# Should return JSON with experiment details
```

### 3. Python Imports
```bash
python -c "import mlflow; import torch; import fastapi; print('✓ All imports successful')"
```

### 4. Sample Data
```bash
# Generate sample CSV if it doesn't exist
python data/scripts/generate_sample_data.py --rows 500 --output data/raw/sample_feedback.csv

# Check file created
ls -lh data/raw/sample_feedback.csv
```

---

## 🔧 Troubleshooting Setup

### Docker Services Won't Start
```bash
# Check Docker daemon
docker ps

# If error: Check Docker is running and has enough resources
docker system df  # Check disk usage
docker system prune  # Clean up unused images

# Restart services
docker-compose restart
```

### PostgreSQL Connection Failed
```bash
# Check if PostgreSQL container is running
docker-compose ps postgres

# Check logs
docker-compose logs postgres

# Verify port 5432 is open
netstat -an | grep 5432

# Try manual connection
psql -U postgres -h localhost -p 5432 -c "SELECT 1"
```

### MLflow Server Issues
```bash
# Check MLflow is running
docker-compose ps mlflow

# Check logs
docker-compose logs mlflow

# Access UI
curl http://localhost:5000

# If connection refused, wait 30 seconds and try again
```

### Python Dependencies Issues
```bash
# Upgrade pip
pip install --upgrade pip

# Clear pip cache
pip cache purge

# Reinstall requirements
pip install --force-reinstall -r training/requirements.txt
```

---

## 📊 Environment Verification Checklist

- [ ] Python virtual environment activated (should see `(venv)` in terminal)
- [ ] Docker services running (`docker-compose ps` shows all services)
- [ ] PostgreSQL accessible (`psql -U postgres -h localhost` connects)
- [ ] Database schema created (`psql -d mlops -c "\dt"` shows tables)
- [ ] MLflow server running (http://localhost:5000 accessible)
- [ ] Python dependencies installed (all `pip list` entries present)
- [ ] Sample data file exists (`data/raw/sample_feedback.csv` present)
- [ ] Configuration files present (`config/*.yaml` files exist)

---

## 🎯 Next Steps

1. ✅ Completed setup
2. Read [`docs/ARCHITECTURE.md`](ARCHITECTURE.md) - Understand system design
3. Read [`docs/PHASES.md`](PHASES.md) - Understand the 4 phases
4. **START BUILDING:** Begin Phase 1 tasks in [`data/README.md`](../data/README.md)

---

## 💻 Quick Reference Commands

```bash
# Start Docker stack
docker-compose -f docker/docker-compose.yaml up -d

# Stop Docker stack
docker-compose -f docker/docker-compose.yaml down

# View Docker logs
docker-compose logs -f [service-name]

# Access PostgreSQL shell
psql -U postgres -h localhost -d mlops

# Run tests
pytest tests/ -v

# Start MLflow UI
# Already running via docker-compose, just visit http://localhost:5000
```

---

## 🚨 Common Issues & Solutions

### Issue: "Cannot connect to PostgreSQL"
**Solution:** 
1. Verify PostgreSQL container is running: `docker-compose ps postgres`
2. Check port 5432 is not already in use
3. Restart PostgreSQL: `docker-compose restart postgres`

### Issue: "MLflow Server not responding"
**Solution:**
1. Wait 30 seconds after starting (needs time to initialize)
2. Check container logs: `docker-compose logs mlflow`
3. Verify port 5000 is accessible: `curl http://localhost:5000`

### Issue: "psycopg2 import error"
**Solution:**
1. Install PostgreSQL development libraries: `pip install psycopg2-binary`
2. Or use alternate: `pip install psycopg2-binary --force-reinstall`

### Issue: "CUDA out of memory during training"
**Solution:**
1. Reduce batch_size in training_config.yaml
2. Use CPU instead: Set `CUDA_VISIBLE_DEVICES=""` before running training

---

## ✨ Setup Complete!

When you see all checklist items ✅, you're ready to start building!

**Next:** Go to [`docs/PHASES.md`](PHASES.md) and start Phase 1!

