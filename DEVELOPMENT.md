# Development Guide

This document provides guidance for implementing the MLOps learning module.

## Project Structure Overview

```
learn-MLOps/
├── README.md                    # Main entry point
├── .env.example                 # Environment variable template
├── config/                      # YAML configuration files
│   ├── database_schema.sql
│   ├── training_config.yaml
│   ├── promotion_rules.yaml
│   ├── validation_rules.yaml
│   └── alert_rules.yaml
├── data/                        # Phase 1: Data Infrastructure
│   ├── README.md               # Phase 1 task guide
│   ├── db_utils.py
│   ├── scripts/
│   │   ├── generate_sample_data.py
│   │   ├── ingest_data.py           (TODO)
│   │   ├── validate_data.py          (TODO)
│   │   ├── split_data.py             (TODO)
│   │   └── ingest_monitor.py        (TODO)
│   └── raw/
│       └── .gitkeep
├── training/                    # Phase 2: Continuous Training
│   ├── README.md               # Phase 2 task guide
│   ├── model_wrapper.py
│   ├── metrics_calculator.py
│   ├── train.py                 (TODO)
│   ├── seed_manager.py          (TODO)
│   ├── requirements.txt
│   └── tests/
│       ├── __init__.py
│       ├── test_model_wrapper.py     (TODO)
│       └── test_metrics.py           (TODO)
├── registry/                    # Phase 3: Model Registry
│   ├── README.md               # Phase 3 task guide
│   ├── promotion_pipeline.py
│   ├── comparison_engine.py     (TODO)
│   ├── model_validation_tests.py (TODO)
│   ├── rollback_script.py       (TODO)
│   └── tests/
│       └── test_promotion.py    (TODO)
├── serving/                     # Phase 4: Production Serving
│   ├── README.md               # Phase 4 task guide
│   ├── serving_app.py
│   ├── inference_logger.py      (TODO)
│   ├── drift_monitor.py
│   ├── alert_module.py          (TODO)
│   ├── monitoring_dashboard.py  (TODO)
│   ├── requirements.txt
│   └── tests/
│       └── test_serving_api.py  (TODO)
├── docker/
│   ├── docker-compose.yaml
│   ├── Dockerfile.mlflow
│   └── Dockerfile.serving
├── docs/
│   ├── ARCHITECTURE.md
│   ├── SETUP.md
│   ├── PHASES.md               # 24-task breakdown
│   └── README.md               # Documentation index
├── mlflow/
│   ├── README.md
│   └── mlflow_config.py         (TODO)
├── notebooks/
│   ├── README.md
│   └── (Jupyter notebooks - TODO)
├── scripts/
│   ├── quickstart.sh
│   ├── quickstart.bat
│   └── (Utility scripts)
├── logs/
│   └── .gitkeep
└── tests/
    ├── __init__.py
    └── conftest.py              (TODO)

(TODO) = Stub created, implementation pending
```

## Implementation Roadmap

### Phase 1: Data Infrastructure (Tasks 1.1 - 1.5)
**Time Estimate**: 8-12 hours

1. Complete `data/db_utils.py` - Database connections and validators
2. Create `data/scripts/ingest_data.py` - Ingestion pipeline
3. Create `data/scripts/validate_data.py` - Validation logic
4. Create `data/scripts/split_data.py` - Train/val/test splitting
5. Create `data/scripts/ingest_monitor.py` - Ingestion monitoring

**Key Concepts**:
- Connection pooling and resource management
- Programmatic data validation
- Stratified splitting for reproducibility

### Phase 2: Continuous Training (Tasks 2.1 - 2.6)
**Time Estimate**: 10-15 hours

1. Complete `training/model_wrapper.py` - Model loading and fine-tuning
2. Complete `training/metrics_calculator.py` - Metric computation
3. Create `training/train.py` - Training orchestration
4. Create `training/seed_manager.py` - Reproducibility utilities
5. Create `training/experiment_manager.py` - Experiment tracking

**Key Concepts**:
- Transfer learning and layer freezing
- MLflow experiment tracking
- Reproducibility with fixed seeds

### Phase 3: Model Registry (Tasks 3.1 - 3.6)
**Time Estimate**: 10-12 hours

1. Create `registry/registry_setup.py` - Registry initialization
2. Create `registry/comparison_engine.py` - Metrics comparison
3. Create `registry/model_validation_tests.py` - Validation tests
4. Complete `registry/promotion_pipeline.py` - Promotion workflow
5. Create `registry/rollback_script.py` - Rollback mechanism

**Key Concepts**:
- MLflow Model Registry API
- Automated promotion with safety gates
- Audit logging and rollback

### Phase 4: Production Serving (Tasks 4.1 - 4.7)
**Time Estimate**: 12-16 hours

1. Complete `serving/serving_app.py` - FastAPI REST API
2. Create `serving/inference_logger.py` - Inference logging
3. Complete `serving/drift_monitor.py` - Statistical drift detection
4. Create `serving/alert_module.py` - Alert generation
5. Create `serving/monitoring_dashboard.py` - Monitoring visualization
6. Test `docker/Dockerfile.serving` - Container deployment

**Key Concepts**:
- REST API design patterns
- Statistical testing (KS-Test, PSI)
- Containerization for deployment

## Implementation Tips

### 1. Start with Stubs
Each phase has skeleton files with TODO comments. Start by reading the docstrings to understand what needs to be implemented.

### 2. Test Incrementally
```bash
# Phase 1 testing
python -m pytest training/tests/test_db_utils.py -v

# Phase 2 testing
python -m pytest training/tests/ -v

# Integration testing
python -m pytest tests/ -v
```

### 3. Logging & Debugging
Use `loguru` for structured logging:
```python
from loguru import logger

logger.info("Training started")
logger.error("Failed to load model")
```

### 4. Database Connection Pattern
```python
from data.db_utils import DatabaseConfig, DatabaseConnector

config = DatabaseConfig()
connector = DatabaseConnector(config)

with connector.get_connection() as conn:
    # Use connection
    result = conn.execute("SELECT * FROM raw_data")
```

### 5. MLflow Usage Pattern
```python
import mlflow

with mlflow.start_run():
    mlflow.log_param("learning_rate", 0.001)
    mlflow.log_metric("f1_score", 0.85)
    mlflow.log_artifact("model.pt")
```

## Common Pitfalls to Avoid

1. **Not handling edge cases**: Empty datasets, missing values, single classes
2. **Hardcoding paths**: Use `pathlib.Path` or environment variables
3. **Forgetting reproducibility**: Always set seeds and version dependencies
4. **Insufficient error handling**: Wrap database calls in try/except
5. **Not logging enough**: Log key decision points and errors

## Testing Strategy

### Unit Tests
Test individual functions in isolation:
```python
def test_validate_schema():
    validator = DataValidator(rules={...})
    is_valid, error = validator.validate_schema({"text": "sample"})
    assert is_valid
```

### Integration Tests
Test multiple components together:
```python
def test_ingest_and_validate():
    # Ingest data
    # Validate data
    # Check database
```

### End-to-End Tests
Test full pipeline:
```bash
# Phase 1 E2E
python data/scripts/ingest_data.py
python data/scripts/validate_data.py
python data/scripts/split_data.py
# Verify splits in database
```

## Debugging Tips

### Database Issues
```bash
# Connect to PostgreSQL directly
psql -h localhost -U postgres -d mlops

# Check tables
\dt

# Count records
SELECT table_name, COUNT(*) as rows FROM ...
```

### MLflow Issues
```bash
# Check tracking URI
mlflow.get_tracking_uri()

# List experiments
mlflow.search_experiments()

# Download artifacts
mlflow.artifacts.download_artifacts(run_id="...", artifact_path="model")
```

### Docker Issues
```bash
# Check container logs
docker-compose logs -f postgres
docker-compose logs -f mlflow

# Restart service
docker-compose restart postgres

# Rebuild image
docker-compose build --no-cache serving
```

## Performance Optimization

### Phase 1: Data Processing
- Use PySpark for large datasets
- Batch insert to database
- Create indexes for frequent queries

### Phase 2: Training
- Use GPU if available
- Implement gradient accumulation
- Use mixed precision training

### Phase 3: Model Registry
- Cache baseline metrics
- Batch promote models
- Archive old versions

### Phase 4: Serving
- Cache model in memory
- Use async operations
- Batch inference logging

## Deployment Checklist

### Pre-Deployment
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Documentation updated
- [ ] Performance benchmarked
- [ ] Security review completed

### Deployment
- [ ] Rollback plan documented
- [ ] Monitoring set up
- [ ] Alerts configured
- [ ] Team notified
- [ ] Gradual rollout (canary if possible)

### Post-Deployment
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Gather feedback
- [ ] Plan next iteration

## References

- [MLflow Documentation](https://mlflow.org/docs/latest/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [HuggingFace Transformers](https://huggingface.co/docs/transformers/)
- [SQLAlchemy ORM](https://docs.sqlalchemy.org/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## Getting Help

1. Check relevant Phase README (e.g., `data/README.md` for Phase 1)
2. Look at docstrings in skeleton files
3. Review test files for usage examples
4. Check `docs/PHASES.md` for task details
5. Consult project `docs/ARCHITECTURE.md` for design decisions
