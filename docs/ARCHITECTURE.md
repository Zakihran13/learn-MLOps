# MLOps Learning Module: System Architecture & Design

**Complete local MLOps infrastructure for learning and production deployment**

---

## 🏗️ System Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                  COMPLETE MLOps INFRASTRUCTURE                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  DATA LAYER (Phase 1)         TRAINING LAYER (Phase 2)         │
│  ┌─────────────────────────┐  ┌──────────────────────────────┐ │
│  │ CSV → PySpark Ingest    │  │ Load Data → Transfer Learn   │ │
│  │ ↓                       │  │ ↓                            │ │
│  │ PostgreSQL raw_data     │  │ Train Model                  │ │
│  │ ↓                       │  │ ↓                            │ │
│  │ Validation (4+ checks)  │  │ MLflow Tracking              │ │
│  │ ↓                       │  │ (params, metrics, artifacts) │ │
│  │ PostgreSQL validated    │  └──────────────────────────────┘ │
│  │ ↓                       │                                    │
│  │ Stratified Split        │  REGISTRY LAYER (Phase 3)         │
│  │ ↓                       │  ┌──────────────────────────────┐ │
│  │ train_split (60%)       │  │ Compare (Champion vs Cand.)  │ │
│  │ val_split (20%)         │  │ ↓                            │ │
│  │ test_split (20%)        │  │ Validate (5 tests)           │ │
│  └─────────────────────────┘  │ ↓                            │ │
│                               │ Auto-Promote                  │ │
│                               │ ↓                            │ │
│                               │ MLflow Model Registry         │ │
│                               │ (staging | production)        │ │
│                               └──────────────────────────────┘ │
│                                                                  │
│  SERVING LAYER (Phase 4)      MONITORING LOOP (Phase 4)         │
│  ┌─────────────────────────┐  ┌──────────────────────────────┐ │
│  │ FastAPI /predict        │  │ Inference Logs               │ │
│  │ ↓                       │  │ ↓                            │ │
│  │ Load production model   │  │ Drift Detection (KS / PSI)   │ │
│  │ ↓                       │  │ ↓                            │ │
│  │ Async inference logging │  │ Alert System                 │ │
│  │ ↓                       │  │ ↓                            │ │
│  │ PostgreSQL inference_l. │  │ Trigger Retraining           │ │
│  │ ↓                       │  │ ↓ (back to Phase 2)          │ │
│  │ Real-time Dashboard     │  │ Closed Loop Complete         │ │
│  └─────────────────────────┘  └──────────────────────────────┘ │
│                                                                  │
│              All containerized with Docker Compose ✓            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 📊 Data Flow

```
CSV Files (Customer Feedback)
    ↓
[PHASE 1] Data Ingestion & Validation
    ├─ ingest_pipeline.py (PySpark)
    ├─ validation_module.py (4+ checks)
    ├─ data_splitter.py (stratified)
    └─ PostgreSQL (raw_data, validated_data, splits)
    ↓
[PHASE 2] Continuous Training
    ├─ train.py (load data, transfer learn, train)
    ├─ metrics_calculator.py (F1, precision, latency)
    ├─ seed_manager.py (reproducibility)
    └─ MLflow Tracking Server (params, metrics, artifacts)
    ↓
[PHASE 3] Model Registry & Promotion
    ├─ comparison_engine.py (champion vs candidate)
    ├─ promotion_pipeline.py (auto-decide)
    ├─ model_validation_tests.py (5 tests)
    └─ MLflow Model Registry (versions, stages)
    ↓
[PHASE 4] Production Serving & Monitoring
    ├─ serving_app.py (FastAPI /predict)
    ├─ inference_logger.py (log every prediction)
    ├─ drift_monitor.py (detect KS/PSI drift)
    ├─ alert_module.py (trigger retraining)
    └─ monitoring_dashboard.py (real-time view)
    ↓
[FEEDBACK LOOP]
    └─ Drift alerts → Retraining (back to Phase 2)
```

---

## 🗄️ Database Schema (PostgreSQL)

### Key Tables

#### 1. raw_data
- Source CSV files, raw data before validation
- Fields: id, ingestion_timestamp, source_file, features (JSONB), raw_text, created_at

#### 2. validated_data
- Clean data that passed all validation checks
- Fields: id, raw_data_id, features (JSONB), text_content, is_valid, validation_errors (JSONB)

#### 3. train_split, val_split, test_split
- Stratified data splits with lineage tracking
- Fields: id, validated_data_id, split_version, created_at

#### 4. inference_logs
- Every prediction logged for monitoring and drift detection
- Fields: id, timestamp, input_features (JSONB), prediction, confidence, model_version, latency_ms, request_id

#### 5. monitoring_alerts
- Alerts triggered by drift detection or other issues
- Fields: id, alert_type, severity, message, metrics (JSONB), created_at

---

## 🔐 Technology Stack

| Component | Tech | Reason |
|-----------|------|--------|
| **Data Store** | PostgreSQL | Reliable, JSON support, complex queries |
| **Processing** | PySpark / Python | Scalability, teaches pipeline concepts |
| **ML Model** | HuggingFace distilBERT | Pre-trained, small, fast, transfer learning |
| **Tracking** | MLflow | Open-source, industry-standard, simple |
| **Serving** | FastAPI | Modern, async, built-in validation |
| **Monitoring** | Custom Python + SQLite | Understand how things work (no black box) |
| **Container** | Docker + Compose | Reproducible stack, deploy anywhere |

---

## 🎯 Design Principles

### 1. Data-First
Quality gates BEFORE training. Data is the foundation.

### 2. Reproducibility
Every experiment repeatable with same data + seed.

### 3. Automation
Minimal manual steps. Decisions programmatic.

### 4. Observability
Everything logged. Metrics at every layer.

### 5. Safety
Baselines, validation, comparison before production.

### 6. Scalability
Local development → Cloud production seamlessly.

---

## 📈 Scaling Path

### Local (Current)
```
PostgreSQL (local)
MLflow (local, SQLite)
Training (local GPU/CPU)
Serving (single instance)
```

### Production (Future)
```
PostgreSQL (RDS / Cloud SQL)
MLflow (managed service)
Training (Spark cluster)
Serving (Kubernetes)
Monitoring (Prometheus + Grafana)
```

Code remains the same; only infrastructure changes.

---

## 🚀 Next: Read [`SETUP.md`](SETUP.md) for step-by-step environment setup

