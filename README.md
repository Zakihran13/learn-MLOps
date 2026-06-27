# 🚀 Comprehensive MLOps Learning Module

**A complete, production-grade machine learning operations system built locally. Learn by building—not by watching.**

## 📖 Quick Start

1. **Read first:** [`docs/OVERVIEW.md`](docs/OVERVIEW.md) - 5 min orientation
2. **Then read:** [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) - 15 min system design
3. **Then execute:** [`docs/SETUP.md`](docs/SETUP.md) - Step-by-step setup
4. **Then build:** Start with Phase 1 tasks in [`docs/PHASES.md`](docs/PHASES.md)

## 🎯 Mission

Build a **sentiment classification service** that:
- ✅ Ingests and validates data automatically
- ✅ Trains models continuously with quality gates
- ✅ Promotes safe versions to production via MLflow
- ✅ Serves predictions via REST API at scale
- ✅ Detects data drift and triggers retraining autonomously
- ✅ Monitors everything in real-time

## 🏗️ The Complete System

```
Data Ingestion (PySpark + PostgreSQL)
         ↓
Data Validation (4+ Quality Checks)
         ↓
Automated Training (MLflow Tracking)
         ↓
Model Comparison (Champion vs Candidate)
         ↓
Automated Promotion (Staging → Production)
         ↓
FastAPI Serving (REST API)
         ↓
Inference Logging (Every Prediction)
         ↓
Drift Detection (KS-Test / PSI)
         ↓
Alert System (Triggers Retraining)
```

## 📊 Project Scope

| What | Details |
|------|---------|
| **Phases** | 4 phases (DataOps → Training → Registry → Serving) |
| **Tasks** | 24 executable tasks with acceptance criteria |
| **Duration** | 16-20 days (full-time) or 4-5 weeks (part-time) |
| **Code** | ~3,000-4,000 lines you write from scratch |
| **Stack** | PostgreSQL, PySpark, MLflow, FastAPI, Docker |
| **Model** | HuggingFace distilBERT (transfer learning) |
| **Environment** | 100% local (Docker containerized) |

## 📂 Repository Structure

```
learn-MLOps/
├── README.md                          # This file
├── docs/                              # Documentation
│   ├── OVERVIEW.md                    # High-level overview
│   ├── ARCHITECTURE.md                # System architecture & design
│   ├── PHASES.md                      # 4-phase detailed breakdown
│   ├── SETUP.md                       # Step-by-step setup guide
│   ├── TASK_CHECKLIST.md              # All 24 tasks with acceptance criteria
│   ├── TROUBLESHOOTING.md             # Common issues & solutions
│   └── REFERENCES.md                  # Tools, libraries, resources
│
├── docker/                            # Docker configuration
│   ├── docker-compose.yaml            # Full stack orchestration
│   ├── Dockerfile.serving             # FastAPI serving container
│   ├── Dockerfile.mlflow              # MLflow server container
│   └── .dockerignore
│
├── config/                            # Configuration files
│   ├── training_config.yaml           # Training hyperparameters
│   ├── promotion_rules.yaml           # Promotion decision rules
│   ├── alert_rules.yaml               # Drift/alert thresholds
│   ├── validation_rules.yaml          # Data validation rules
│   └── database_schema.sql            # PostgreSQL schema
│
├── data/                              # Data layer (Phase 1)
│   ├── raw/                           # Raw data dumps
│   │   └── sample_feedback.csv
│   ├── scripts/
│   │   ├── ingest_pipeline.py         # PySpark ingestion
│   │   ├── validation_module.py       # Data validation
│   │   ├── data_splitter.py           # Train/val/test split
│   │   └── monitoring_script.py       # Data quality monitoring
│   ├── schema/
│   │   └── database_schema.sql
│   └── README.md
│
├── training/                          # Training layer (Phase 2)
│   ├── train.py                       # Main training orchestrator
│   ├── model_wrapper.py               # Transfer learning wrapper
│   ├── metrics_calculator.py          # Metrics computation
│   ├── seed_manager.py                # Reproducibility manager
│   ├── requirements.txt               # Python dependencies
│   ├── tests/
│   │   ├── test_training.py
│   │   └── conftest.py
│   └── README.md
│
├── registry/                          # Registry layer (Phase 3)
│   ├── comparison_engine.py           # Model comparison logic
│   ├── promotion_pipeline.py          # Promotion orchestrator
│   ├── model_validation_tests.py      # Pre-promotion validation
│   ├── rollback_script.py             # Rollback to previous version
│   ├── tests/
│   │   └── test_promotion.py
│   └── README.md
│
├── serving/                           # Serving layer (Phase 4)
│   ├── serving_app.py                 # FastAPI REST API
│   ├── inference_logger.py            # Inference logging
│   ├── drift_monitor.py               # Drift detection
│   ├── alert_module.py                # Alerting system
│   ├── monitoring_dashboard.py        # Real-time dashboard
│   ├── tests/
│   │   ├── test_api.py
│   │   └── test_drift.py
│   └── README.md
│
├── notebooks/                         # Jupyter notebooks (optional)
│   ├── 01_explore_data.ipynb
│   ├── 02_training_walkthrough.ipynb
│   └── 03_monitoring_analysis.ipynb
│
├── mlflow/                            # MLflow artifacts (local)
│   ├── backend.db                     # SQLite backend (auto-created)
│   └── artifacts/                     # Model artifacts (auto-created)
│
├── logs/                              # Runtime logs
│   ├── ingestion.log
│   ├── training.log
│   ├── serving.log
│   └── monitoring.log
│
└── tests/                             # Integration tests
    ├── test_end_to_end.py
    ├── test_reproducibility.py
    └── conftest.py
```

## 🚀 Quick Start Commands

### 1. Setup Environment
```bash
# Clone and enter directory
cd learn-MLOps

# Create Python virtual environment
python -m venv venv
source venv/Scripts/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r training/requirements.txt
pip install -r serving/requirements.txt
```

### 2. Start Docker Stack (PostgreSQL + MLflow)
```bash
docker-compose -f docker/docker-compose.yaml up -d
```

### 3. Initialize Database
```bash
psql -U postgres -h localhost -d mlops < config/database_schema.sql
```

### 4. Run Data Ingestion (Phase 1)
```bash
python data/scripts/ingest_pipeline.py
```

### 5. Run Training (Phase 2)
```bash
python training/train.py --config config/training_config.yaml
```

### 6. View MLflow Dashboard
Open: http://localhost:5000

### 7. Start Serving API (Phase 4)
```bash
python serving/serving_app.py
```

### 8. Test Prediction
```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"features": {"text": "Great product!"}}'
```

## 📋 The 4 Phases

### Phase 1: Data Infrastructure & Ingestion Quality (3-4 days)
Build PostgreSQL-backed data pipeline with automated quality gates.

- Setup PostgreSQL with pgAdmin
- Build PySpark ingestion script
- Implement 4+ data validation checks
- Create reproducible train/val/test splits
- Setup data quality monitoring

**Location:** `data/scripts/`

### Phase 2: Continuous Training & MLflow Automation (4-5 days)
Implement fully automated, reproducible training with comprehensive logging.

- Setup MLflow Tracking Server
- Build transfer learning model wrapper
- Create training orchestration script
- Define comprehensive metrics
- Ensure reproducibility

**Location:** `training/`

### Phase 3: Model Registry & Promotion (3-4 days)
Automate model comparison and safe promotion to production.

- Setup MLflow Model Registry
- Build comparison engine
- Implement promotion pipeline
- Define validation tests
- Design rollback strategy

**Location:** `registry/`

### Phase 4: Production Serving & Monitoring (4-5 days)
Deploy serving API, monitor for drift, trigger retraining autonomously.

- Build FastAPI serving API
- Containerize with Docker
- Implement inference logging
- Build drift detection
- Setup alerting system
- Create monitoring dashboard

**Location:** `serving/`

## 🎓 Learning Outcomes

By completing this module, you will:

✅ Design end-to-end ML systems with data-centric architecture
✅ Implement automated quality gates at every stage
✅ Manage model lifecycle via MLflow (tracking, registry, promotion)
✅ Deploy containerized ML services with REST APIs
✅ Detect data drift mathematically (KS-Test / PSI)
✅ Implement autonomous retraining triggered by drift
✅ Monitor production ML systems operationally
✅ Build reproducible systems that work consistently

## 📊 Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Data** | PostgreSQL (Docker) | Source of truth for all data |
| **Processing** | PySpark / Python | Scalable data pipelines |
| **ML Model** | HuggingFace distilBERT | Transfer learning on text |
| **Tracking** | MLflow | Experiment tracking & registry |
| **Serving** | FastAPI | REST API for predictions |
| **Monitoring** | Custom Python | Inference logging & drift detection |
| **Container** | Docker + Compose | Reproducible stack |

## 🔄 The Feedback Loop

This system implements a **closed-loop retraining pipeline**:

```
Production API
    ↓ (every inference)
Log inference data
    ↓ (stored in PostgreSQL)
Drift detection (hourly or every 100 inferences)
    ↓ (if drift detected)
Alert system triggers
    ↓ (queues retraining)
Training pipeline runs
    ↓ (logs to MLflow)
Promotion pipeline evaluates
    ↓ (if passing all tests)
Model promoted to staging/production
    ↓ (MLflow Registry updated)
Serving app reloads model
    ↓ (next inference with new model)
Back to step 1
```

## 📝 Documentation

| Document | Purpose | Time |
|----------|---------|------|
| `docs/OVERVIEW.md` | High-level intro | 5 min |
| `docs/ARCHITECTURE.md` | System design & components | 15 min |
| `docs/PHASES.md` | Detailed 4-phase breakdown | 30 min |
| `docs/SETUP.md` | Step-by-step setup | 20 min |
| `docs/TASK_CHECKLIST.md` | All 24 tasks with criteria | 30 min |
| `data/README.md` | Phase 1 guide | 10 min |
| `training/README.md` | Phase 2 guide | 10 min |
| `registry/README.md` | Phase 3 guide | 10 min |
| `serving/README.md` | Phase 4 guide | 10 min |

## 🎯 Success Metrics

### By End of Each Phase

**Phase 1:**
- [ ] PostgreSQL running with all tables created
- [ ] Sample data ingested successfully
- [ ] All validation checks passing
- [ ] Train/val/test splits created

**Phase 2:**
- [ ] MLflow server running at localhost:5000
- [ ] Training completes successfully
- [ ] Metrics logged to MLflow
- [ ] Same seed produces same model (reproducibility verified)

**Phase 3:**
- [ ] Models registered in MLflow
- [ ] Comparison engine works correctly
- [ ] Promotion pipeline auto-promotes qualified models
- [ ] Rollback tested successfully

**Phase 4:**
- [ ] /predict endpoint returns predictions
- [ ] Inferences logged correctly
- [ ] Drift detection triggers alerts
- [ ] Dashboard shows real-time metrics

**Integration:**
- [ ] End-to-end flow: Data → Training → Promotion → Serving
- [ ] Drift triggers retraining automatically
- [ ] New model promoted if qualified
- [ ] Full system runs locally via docker-compose

## 🚦 Execution Roadmap

```
Week 1:
  Day 1-2: Phase 1 (Data Infrastructure)
  Day 3-5: Phase 2 (Training Pipeline)

Week 2:
  Day 6-8: Phase 3 (Model Registry)
  Day 9-12: Phase 4 Part 1 (Serving)

Week 3:
  Day 13-14: Phase 4 Part 2 (Monitoring)
  Day 15-16: Integration Testing
  Day 17+: Documentation & Optimization
```

## 🤝 Contributing & Extending

After completing the core module:
- Add ensemble methods (voting, stacking)
- Implement A/B testing framework
- Add model explainability (SHAP, feature importance)
- Setup CI/CD pipeline
- Deploy to Kubernetes
- Add advanced monitoring dashboards

## 📚 Resources

- [MLflow Documentation](https://mlflow.org/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [HuggingFace Transformers](https://huggingface.co/docs/transformers/)

## 🎓 Learning Philosophy

This is **not** a tutorial—it's a **learning journey**:

- Learn by building (every concept implemented)
- Progressive complexity (simple → sophisticated)
- Real-world patterns (production-grade)
- Deep ownership (you understand every line)
- Hands-on debugging (bugs teach more than code)

## ✨ What Makes This Different

✅ **Complete System:** Not just model training—full MLOps stack
✅ **Executable:** Every component is code you write
✅ **Local First:** Develop locally, scales to production
✅ **Self-Contained:** Docker for reproducibility
✅ **Well-Documented:** Every piece explained thoroughly
✅ **Production-Ready:** Patterns used in real systems
✅ **Deep Learning:** Understand *why*, not just *how*

## 🚀 Ready to Start?

1. Open [`docs/SETUP.md`](docs/SETUP.md) for step-by-step instructions
2. Follow the 4 phases in [`docs/PHASES.md`](docs/PHASES.md)
3. Reference [`docs/TASK_CHECKLIST.md`](docs/TASK_CHECKLIST.md) for detailed requirements
4. Build each phase with support from [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)

## 📞 Questions?

Refer to:
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) - System design questions
- [`docs/SETUP.md`](docs/SETUP.md) - Setup issues
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) - Common problems
- Each module's `README.md` - Phase-specific guidance

---

**Let's build something amazing! 🚀**

