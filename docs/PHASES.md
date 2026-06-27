# MLOps Learning Module: 4-Phase Implementation Guide

**Comprehensive breakdown of all 24 tasks across 4 phases**

---

## 📊 Project Overview

| Phase | Name | Duration | Tasks | Focus | Output |
|-------|------|----------|-------|-------|--------|
| 1 | Data Infrastructure | 3-4 days | 5 | Quality gates, validation | Clean data splits in PostgreSQL |
| 2 | Continuous Training | 4-5 days | 6 | Reproducible training, logging | MLflow experiments & artifacts |
| 3 | Model Registry | 3-4 days | 6 | Comparison, promotion, safety | Auto-promotion to production |
| 4 | Production Serving | 4-5 days | 7 | REST API, monitoring, drift | Autonomous retraining loop |

**Total:** 24 tasks | **Duration:** 16-20 days

---

## 🏗️ PHASE 1: Data Infrastructure & Automated Ingestion (3-4 days)

### Goal
Build PostgreSQL-backed data pipeline with automated quality gates.

### 5 Tasks

#### Task 1.1: Setup PostgreSQL & Database Schema
**Deliverables:**
- [ ] PostgreSQL running in Docker (port 5432)
- [ ] pgAdmin running (port 5050)
- [ ] All tables created (raw_data, validated_data, splits, audit_logs)
- [ ] Test connection script working

**Success Criteria:**
- `psql -U postgres -h localhost -d mlops -c "\dt"` shows 7 tables
- `docker-compose ps` shows postgres running
- pgAdmin UI accessible at http://localhost:5050

**Implementation:** Use `docker/docker-compose.yaml` and `config/database_schema.sql`

---

#### Task 1.2: Build PySpark Ingestion Pipeline
**Deliverables:**
- [ ] `data/scripts/ingest_pipeline.py` (reads CSV, normalizes types, writes to PostgreSQL)
- [ ] Sample CSV file: `data/raw/sample_feedback.csv` (500-1000 records)
- [ ] Execution logs showing ingestion stats
- [ ] Data lineage captured (source file, timestamp)

**What It Does:**
```python
# Pseudocode flow
1. Read CSV file from data/raw/
2. Normalize data types (strings, dates, numbers)
3. Handle missing values consistently
4. Write to PostgreSQL raw_data table
5. Log ingestion metrics (rows, columns, timestamp)
```

**Success Criteria:**
- Script runs without errors
- Data successfully written to PostgreSQL
- All 500+ rows ingested
- Data types correct in database

---

#### Task 1.3: Implement Data Validation Module
**Deliverables:**
- [ ] `data/scripts/validation_module.py` (4+ validation checks)
- [ ] `config/validation_rules.yaml` (thresholds for checks)
- [ ] Unit tests for each validation rule
- [ ] Validation audit log in database

**Validation Checks (minimum 4):**
1. **Schema Validation:** Columns and types match expected
2. **Missing Value Check:** Alert if % missing > threshold (e.g., 10%)
3. **Anomaly Detection:** Flag outliers > 3 sigma from mean
4. **Cardinality Check:** Detect new categories in categorical columns

**Success Criteria:**
- All 4 checks pass on clean data
- Checks correctly fail on corrupted data
- Validation results logged to database
- Alerts triggered for threshold breaches

---

#### Task 1.4: Create Data Splitter with Lineage
**Deliverables:**
- [ ] `data/scripts/data_splitter.py` (stratified split logic)
- [ ] PostgreSQL splits tables (train_split, val_split, test_split)
- [ ] Lineage tracking (parent row IDs, split version, timestamp)
- [ ] Test fixtures for different data distributions
- [ ] Reproducibility via seed

**What It Does:**
```
Validated Data
    ↓ (stratified by label)
Train Split (60%)   ← PostgreSQL train_split table
Validation Split (20%)   ← PostgreSQL val_split table
Test Split (20%)    ← PostgreSQL test_split table
```

**Success Criteria:**
- Splits created in PostgreSQL
- Ratios match 60/20/20 within 1%
- Stratified (class distribution preserved)
- Same seed produces identical splits
- No data leakage between splits

---

#### Task 1.5: Setup Data Quality Monitoring
**Deliverables:**
- [ ] `data/scripts/monitoring_script.py` (metrics logging)
- [ ] `logs/ingestion_metrics.json` (daily metrics file)
- [ ] Dashboard HTML (optional but recommended)
- [ ] Query functions for metrics analysis

**Metrics to Track:**
- Rows ingested per run
- Validation pass/fail rate
- Schema drift flags
- Average ingestion latency

**Success Criteria:**
- Metrics logged after each ingestion
- Dashboard displays current metrics
- Historical trends visible

---

### Phase 1 Checklist
- [ ] PostgreSQL running with all tables
- [ ] Sample data ingested successfully (500+ rows)
- [ ] All validation checks passing (≥80% pass rate on sample)
- [ ] Train/val/test splits created (60/20/20)
- [ ] Monitoring showing metrics
- [ ] Data lineage traceable

---

## 🎓 PHASE 2: Continuous Training & MLflow Automation (4-5 days)

### Goal
Implement fully automated, reproducible training with comprehensive logging.

### 6 Tasks

#### Task 2.1: Setup MLflow Tracking Server
**Deliverables:**
- [ ] MLflow server running in Docker (port 5000)
- [ ] SQLite backend configured (`mlflow/mlflow.db`)
- [ ] Local artifact storage configured (`mlflow/artifacts/`)
- [ ] MLflow UI accessible at http://localhost:5000

**Success Criteria:**
- `docker-compose ps` shows mlflow running
- http://localhost:5000 accessible and responsive
- Can create experiments via UI
- Artifacts properly stored

---

#### Task 2.2: Build Transfer Learning Model Wrapper
**Deliverables:**
- [ ] `training/model_wrapper.py` (HuggingFace distilBERT wrapper)
- [ ] `training/requirements.txt` (pinned dependencies)
- [ ] `config/training_config.yaml` (hyperparameters)
- [ ] Unit tests verifying initialization and forward pass

**Model Architecture:**
```python
# Pseudocode
class TransferLearningModel:
    def __init__(self, model_name="distilbert-base-uncased"):
        self.model = load_pretrained(model_name)
        self.freeze_first_n_layers(8)  # Freeze bottom layers
        self.add_custom_head()  # Add classification head
    
    def forward(self, input_ids, attention_mask):
        return self.model(input_ids, attention_mask)
```

**Success Criteria:**
- Model loads without errors
- Forward pass works on sample input
- Gradient computation works for unfrozen layers
- Frozen layers have no gradients

---

#### Task 2.3: Build Automated Training Script
**Deliverables:**
- [ ] `training/train.py` (main training orchestrator)
- [ ] `training/tests/test_training.py` (unit tests)
- [ ] Training execution logs
- [ ] Model artifacts in MLflow

**Training Flow:**
```
1. Load train/val splits from PostgreSQL
2. Initialize seed_manager (set all seeds for reproducibility)
3. Initialize transfer learning model
4. Train for N epochs:
   - Mini-batch training
   - Compute metrics on validation
   - Log to MLflow each epoch
5. Save model artifact
6. Log final metrics to MLflow
```

**Success Criteria:**
- Training completes successfully
- Metrics computed and logged to MLflow
- Model artifact saved
- Run visible in MLflow UI

---

#### Task 2.4: Define Comprehensive Metrics
**Deliverables:**
- [ ] `training/metrics_calculator.py` (metric functions)
- [ ] Metrics logged to MLflow (F1, precision, recall, latency)
- [ ] Confusion matrix visualization
- [ ] Sample logged metrics in MLflow

**Metrics to Log:**
- F1-score (macro and micro)
- Precision, Recall, Accuracy
- Confusion matrix
- Training loss per epoch
- Validation latency (ms)
- Inference throughput

**Success Criteria:**
- All metrics computed correctly
- Logged to MLflow
- Visible in MLflow UI
- Latency measured accurately

---

#### Task 2.5: Create Experiment Tracking Template
**Deliverables:**
- [ ] `training/experiment_config.py` (metadata structure)
- [ ] MLflow naming convention documentation
- [ ] Sample experiments created
- [ ] Configuration validation

**Experiment Metadata:**
```yaml
experiment:
  name: "sentiment-classifier-v1"
  model_version: "1.2.3"
  data_version: "sha256:abc123..."
  training_datetime: "2026-06-27T13:00:00Z"
  git_commit: "abc1234def5678..."
  hyperparameters:
    learning_rate: 2e-5
    batch_size: 32
    num_epochs: 3
```

**Success Criteria:**
- Naming convention documented
- Experiments follow convention
- Metadata complete and queryable

---

#### Task 2.6: Ensure Reproducibility
**Deliverables:**
- [ ] `training/seed_manager.py` (centralized seed setting)
- [ ] `training/requirements.txt` (pinned versions)
- [ ] Training execution script with lineage
- [ ] Docker image with pinned deps
- [ ] Reproducibility verification test

**Reproducibility Checklist:**
- [ ] Random seeds set (Python, NumPy, Torch, Transformers)
- [ ] Data splits versioned
- [ ] Dependencies pinned
- [ ] Training command documented
- [ ] Lineage tracked

**Success Criteria:**
- Two training runs with same seed produce identical results
- Lineage fully traceable (data → model → MLflow run)

---

### Phase 2 Checklist
- [ ] MLflow server running at http://localhost:5000
- [ ] Training completes successfully
- [ ] Metrics logged to MLflow
- [ ] Model artifact saved
- [ ] Same seed produces identical results (reproducibility verified)
- [ ] Full lineage traced from data to model

---

## 🏆 PHASE 3: Model Registry & Promotion Logic (3-4 days)

### Goal
Automate model comparison and safe promotion to production.

### 6 Tasks

#### Task 3.1: Setup MLflow Model Registry
**Deliverables:**
- [ ] Model Registry initialized
- [ ] Naming conventions documented
- [ ] Aliases configured (production, staging, champion)
- [ ] Registration script/function

**Success Criteria:**
- Models register successfully
- Aliases configurable
- Registry queryable

---

#### Task 3.2: Establish Production Baseline
**Deliverables:**
- [ ] Baseline model registered as "champion"
- [ ] Baseline metrics captured
- [ ] Metadata schema defined
- [ ] Documentation

**Success Criteria:**
- Baseline model in Registry
- Baseline metrics retrievable
- Tags accurate

---

#### Task 3.3: Build Model Comparison Engine
**Deliverables:**
- [ ] `registry/comparison_engine.py`
- [ ] Comparison metrics report (JSON)
- [ ] Side-by-side performance table
- [ ] Unit tests

**Comparison Logic:**
```
1. Load champion model from Registry
2. Load candidate model
3. Evaluate both on validation slice
4. Compare metrics (F1, latency, precision, recall)
5. Return: pass/fail verdict + metrics delta
```

**Success Criteria:**
- Comparison runs successfully
- Report generated
- Metrics delta calculated correctly

---

#### Task 3.4: Implement Promotion Pipeline
**Deliverables:**
- [ ] `registry/promotion_pipeline.py`
- [ ] `config/promotion_rules.yaml`
- [ ] Decision logs (JSON)
- [ ] Manual approval integration (optional)

**Promotion Rules:**
```yaml
F1-score >= baseline F1 - delta (e.g., max 2% drop)
Latency <= max_latency (e.g., 100ms)
No inference errors on validation
→ If all pass: auto-transition to "staging"
```

**Success Criteria:**
- Pipeline executes end-to-end
- Decision logic correct
- Model transitions when passing
- Decisions logged

---

#### Task 3.5: Define Model Validation Tests
**Deliverables:**
- [ ] `registry/model_validation_tests.py` (5+ tests)
- [ ] Test report
- [ ] Sample passing/failing tests

**Validation Tests:**
1. Inference works on 100 random validation samples (no errors)
2. Output shape matches expected (batch_size, num_classes)
3. No NaN or Inf values in predictions
4. Inference latency < max threshold
5. Model loads correctly from Registry

**Success Criteria:**
- Tests pass on valid model
- Tests fail on corrupted model

---

#### Task 3.6: Design Rollback Strategy
**Deliverables:**
- [ ] `registry/rollback_script.py`
- [ ] Rollback decision triggers documented
- [ ] Rollback documentation
- [ ] Audit logging

**Rollback Triggers:**
- Production model fails validation
- Monitoring detects performance drop
- Manual rollback request

**Success Criteria:**
- Rollback executes successfully
- Previous model restored
- Event logged

---

### Phase 3 Checklist
- [ ] Models registered in MLflow
- [ ] Comparison engine works
- [ ] Promotion rules applied correctly
- [ ] Rollback tested successfully
- [ ] Decision logs complete

---

## 🚀 PHASE 4: Production Serving & Drift Detection (4-5 days)

### Goal
Deploy serving API, monitor for drift, trigger retraining autonomously.

### 7 Tasks

#### Task 4.1: Build FastAPI Serving Wrapper
**Deliverables:**
- [ ] `serving/serving_app.py` (FastAPI application)
- [ ] OpenAPI documentation (auto-generated)
- [ ] Unit tests for endpoints
- [ ] API documentation

**Endpoints:**
```
POST /predict
  Input: {"features": {"text": "..."}}
  Output: {"prediction": "...", "confidence": 0.95, "model_version": "v1.2", "latency_ms": 45}

GET /health
  Output: 200 OK

GET /model-info
  Output: {"version": "v1.2", "training_date": "2026-06-20", "f1_score": 0.89}
```

**Success Criteria:**
- API starts without errors
- /predict returns correct predictions
- /health responds with 200
- OpenAPI docs accessible

---

#### Task 4.2: Containerize Serving Application
**Deliverables:**
- [ ] `docker/Dockerfile.serving`
- [ ] `.dockerignore`
- [ ] docker-compose entry for serving
- [ ] Tested image runs locally

**Success Criteria:**
- Image builds without errors
- Container runs: `docker run -p 8000:8000 mlops-serving`
- /predict endpoint responds

---

#### Task 4.3: Create Inference Request Logger
**Deliverables:**
- [ ] `serving/inference_logger.py` (async logging)
- [ ] Database schema for inference_logs
- [ ] Async logging integration in FastAPI
- [ ] Query functions

**Logged Fields:**
- timestamp, input_features, prediction, confidence
- model_version, inference_latency_ms, request_id

**Success Criteria:**
- Logging doesn't block API
- All inferences logged
- Queries efficient

---

#### Task 4.4: Implement Data Drift Detection
**Deliverables:**
- [ ] `serving/drift_monitor.py`
- [ ] KS-Test and PSI calculation
- [ ] Drift monitoring loop
- [ ] Alert thresholds

**Drift Detection:**
```
Every 100 inferences or hourly:
1. Read recent inference features
2. Compare vs training dataset distribution
3. KS-Test for each feature
4. Flag if p-value < 0.05 or PSI > 0.1
```

**Success Criteria:**
- Drift detected on real shifted data
- No false positives on stable data
- Alerts logged

---

#### Task 4.5: Setup Alert Mechanism
**Deliverables:**
- [ ] `serving/alert_module.py`
- [ ] `config/alert_rules.yaml`
- [ ] Drift alert logs
- [ ] Integration with retraining

**Alert Actions:**
- Log to monitoring_alerts table
- Trigger alert file/flag
- Trigger retraining (call train.py)

**Success Criteria:**
- Alerts logged correctly
- Retraining triggered when drift detected

---

#### Task 4.6: Deploy Full Stack End-to-End
**Deliverables:**
- [ ] Full `docker-compose.yaml` (PostgreSQL + MLflow + serving)
- [ ] End-to-end test script
- [ ] Load testing (10k requests)
- [ ] Deployment checklist

**Tests:**
- POST /predict returns predictions
- Inferences logged
- Drift detection runs
- Full flow works

**Success Criteria:**
- `docker-compose up` starts all services
- All endpoints work
- Inferences logged
- Drift detection works

---

#### Task 4.7: Build Monitoring Dashboard
**Deliverables:**
- [ ] `serving/monitoring_dashboard.py`
- [ ] Real-time metrics updates
- [ ] Screenshot examples

**Metrics Displayed:**
- Inference volume (requests/hour)
- Average latency (ms)
- Active model version
- Drift score
- Recent alert count
- Retraining count

**Success Criteria:**
- Dashboard displays accurate metrics
- Updates in real-time
- Easy to understand at a glance

---

### Phase 4 Checklist
- [ ] /predict endpoint returns predictions
- [ ] Inferences logged correctly
- [ ] Drift detection triggers alerts
- [ ] Dashboard shows real-time metrics
- [ ] Full end-to-end flow tested
- [ ] Docker stack deployable

---

## ✅ Integration & End-to-End Testing (2-3 days)

### Checklist
- [ ] Data → Training → Promotion → Serving pipeline works
- [ ] Drift triggers retraining
- [ ] New model promoted if qualified
- [ ] Rollback scenario tested
- [ ] All logs captured
- [ ] Full documentation complete

---

## 📋 Success Criteria Summary

| Phase | Success Criteria |
|-------|-----------------|
| 1 | Data flows: CSV → PostgreSQL with quality gates ✓ |
| 2 | Training fully automated and logged to MLflow ✓ |
| 3 | Models promoted automatically based on rules ✓ |
| 4 | Autonomous retraining triggered by drift ✓ |
| All | End-to-end system works locally via docker-compose ✓ |

---

## 🎯 Next: Start Phase 1!

Navigate to [`../data/README.md`](../data/README.md) for Phase 1 detailed guide.

