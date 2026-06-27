# Phase 4: Containerized Deployment, Production Serving, & Drift Detection

## Overview

Phase 4 deploys the model for **production inference** with real-time monitoring, drift detection, and automated retraining triggers. This phase closes the ML loop with continuous monitoring and feedback.

## Directory Structure

```
serving/
├── serving_app.py            # FastAPI REST API server
├── inference_logger.py       # Log inference requests/responses
├── drift_monitor.py          # Statistical drift detection
├── alert_module.py           # Alert generation and routing
├── monitoring_dashboard.py   # Visualization (optional)
├── requirements.txt          # Python dependencies ✓ (Created)
└── tests/
    └── test_serving_api.py

docker/
└── Dockerfile.serving        # Container image ✓ (Created)
```

## Tasks (4.1 - 4.7)

### Task 4.1: FastAPI Serving Application
**Objective:** Build REST API for real-time model inference.

**Files to Complete:**
- `serving/serving_app.py` → Complete all route handlers

**Implementation Steps:**
1. Complete `InferenceServer` class:
   - `load_model()` - Load production model from MLflow registry
   - `predict()` - Execute inference with latency tracking
   - `health_check()` - System health status

2. Implement FastAPI routes:
   - `POST /predict` - Accept text, return prediction
     - Input validation (non-empty, max length)
     - Generate request_id if not provided
     - Execute inference
     - Log to database
     - Return structured response
   
   - `GET /health` - Health check endpoint
   
   - `GET /model/version` - Current model version info
   
   - `GET /inference/stats?window_minutes=60` - Inference statistics
   
   - `POST /model/reload` - Reload model (for updates)

3. Add error handling:
   - 400: Invalid input
   - 503: Model not loaded or database unavailable
   - 500: Unexpected errors

4. Implement request validation:
   ```python
   class PredictionRequest(BaseModel):
       text: str = Field(..., min_length=1, max_length=1000)
       request_id: Optional[str] = None
   ```

**Success Criteria:**
- API server starts without errors
- Can make prediction requests via `curl` or `requests`
- Latency < 100ms per request
- Health check returns status

---

### Task 4.2: Inference Request/Response Logging
**Objective:** Capture all inference data for monitoring and analysis.

**Files to Complete:**
- `serving/inference_logger.py` (New stub)
- `serving/serving_app.py` → Use in `/predict` route

**Implementation Steps:**
1. Create `serving/inference_logger.py`:
   - `InferenceLogger` class to log to `inference_logs` table
   - Log fields: timestamp, input text, prediction, confidence, latency_ms, model_version, request_id
   - Extract features for drift detection (text length, word count, etc.)

2. Async logging:
   - Use `BackgroundTasks` in FastAPI to log asynchronously
   - Don't block prediction response on logging

3. Call in `/predict` route:
   ```python
   background_tasks.add_task(
       logger.log_inference,
       request_id=request_id,
       text=request.text,
       prediction=prediction,
       ...
   )
   ```

4. Implement `get_recent_inferences()` for drift detection

**Success Criteria:**
- Every inference logged to database
- Logging doesn't block response
- Can retrieve recent inferences

---

### Task 4.3: Data Drift Detection
**Objective:** Detect feature distribution changes using statistical tests.

**Files to Complete:**
- `serving/drift_monitor.py` → Complete all methods

**Implementation Steps:**
1. Complete `DriftDetector` class:
   - `ks_test()` - Kolmogorov-Smirnov test for continuous features
   - `calculate_psi()` - Population Stability Index for categorical features
   - `check_feature_drift()` - Drift check for single feature
   - `check_multivariate_drift()` - Multi-feature drift detection

2. Complete `SlidingWindowDriftMonitor`:
   - Maintain window of recent inferences
   - Check drift every N inferences (100 by default)
   - Return drift alert if detected

3. KS-Test implementation:
   ```python
   from scipy.stats import ks_2samp
   statistic, p_value = ks_2samp(baseline, current)
   drift = p_value < 0.05  # < 5% chance distributions are same
   ```

4. PSI implementation:
   ```
   PSI = Sum((% current - % baseline) * ln(% current / % baseline))
   threshold = 0.1  # Alert if PSI > 0.1
   ```

5. Load baseline distribution from training data:
   - Query `train_split` from database
   - Compute feature distributions
   - Use for all drift comparisons

**Success Criteria:**
- KS-Test correctly detects distribution shift
- PSI correctly calculated
- Sliding window processes inferences incrementally
- Drift alerts generated when detected

---

### Task 4.4: Monitoring Alerts & Actions
**Objective:** Generate alerts and trigger responses on drift/degradation.

**Files to Complete:**
- `serving/alert_module.py` (New stub)
- `serving/drift_monitor.py` → `DriftAlertHandler`

**Implementation Steps:**
1. Create `serving/alert_module.py`:
   - `AlertGenerator` - Create alerts from events
   - `AlertDispatcher` - Route alerts (database, logs, notifications)
   - `AlertAcknowledgement` - Track alert status

2. Implement `DriftAlertHandler`:
   - `log_drift_alert()` - Insert into `monitoring_alerts` table
   - `trigger_retraining_pipeline()` - Submit retraining job
   - `send_notification()` - Send alert (log only for now)

3. Alert types:
   - **Drift Alert** (severity: HIGH)
     - Feature: which feature drifted
     - Method: KS-Test or PSI
     - Statistic: test value
     - Action: trigger retraining
   
   - **Performance Alert** (severity: MEDIUM/HIGH)
     - Metric: F1-score, latency, error rate
     - Window: last N inferences
     - Threshold breached
   
   - **Infrastructure Alert** (severity: CRITICAL)
     - Database unavailable
     - Model loading failed
     - API errors

4. Implement alert persistence:
   - Log to `monitoring_alerts` table
   - Retention: 30 days (configurable)
   - Acknowledgement tracking

**Success Criteria:**
- Drift alerts generated and logged
- Alert database records created
- Alerts retrievable for dashboard/UI

---

### Task 4.5: Containerized Serving
**Objective:** Package serving application in Docker for deployment.

**Files to Complete:**
- `docker/Dockerfile.serving` ✓ (Created)

**Implementation Steps:**
1. Build Docker image:
   ```bash
   docker build -f docker/Dockerfile.serving -t mlops-serving:latest .
   ```

2. Update `docker/docker-compose.yaml` to include serving service:
   ```yaml
   serving:
     build:
       context: .
       dockerfile: docker/Dockerfile.serving
     ports:
       - "8000:8000"
     depends_on:
       - postgres
       - mlflow
     networks:
       - mlops-network
     healthcheck:
       test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
       interval: 30s
       timeout: 10s
       retries: 3
   ```

3. Run containerized serving:
   ```bash
   docker-compose -f docker/docker-compose.yaml up serving -d
   ```

4. Test from container:
   ```bash
   docker exec mlops-serving curl http://localhost:8000/health
   ```

**Success Criteria:**
- Docker image builds without errors
- Container starts and serves requests
- Health checks pass

---

### Task 4.6: Performance Monitoring Dashboard
**Objective:** Visualize inference metrics and model performance.

**Files to Complete:**
- `serving/monitoring_dashboard.py` (New stub - optional, can use MLflow UI)

**Implementation Steps:**
1. Create `serving/monitoring_dashboard.py` (optional):
   - Query `inference_logs` table
   - Compute statistics: latency percentiles, accuracy, error rate
   - Query `monitoring_alerts` table
   - Display drift events

2. Or use existing tools:
   - MLflow UI for model metrics
   - Grafana dashboard connected to PostgreSQL
   - Jupyter notebooks for ad-hoc analysis

3. Implement `/inference/stats` route in `serving_app.py`:
   - Latency: p50, p95, p99
   - Accuracy: F1, precision, recall (on recent window)
   - Volume: requests per minute
   - Error rate: % failed requests

**Success Criteria:**
- Can view inference statistics
- Drift events visualized
- Performance trends tracked

---

### Task 4.7: Closed-Loop Retraining Trigger
**Objective:** Automatically trigger retraining when drift detected.

**Files to Complete:**
- `serving/alert_module.py` → Implement retraining trigger
- Create `scripts/trigger_retraining.py` (New stub)

**Implementation Steps:**
1. Implement retraining trigger:
   - When drift detected:
     - Log alert with "trigger_retraining" action
     - Submit retraining job (can be via shell script, Airflow, etc.)
   
2. Create `scripts/trigger_retraining.py`:
   - Execute Phase 2 training with latest data
   - Log new run to MLflow
   - Execute Phase 3 promotion workflow
   - If promoted, update serving model

3. Full closed-loop:
   ```
   Production Inference → Drift Detected → Alert → Retrain → 
   Compare → Promote → Update Serving → Resume Inference
   ```

4. For local development:
   - Manual trigger via CLI: `python scripts/trigger_retraining.py`
   - In production: automated via Airflow/CI-CD

**Success Criteria:**
- Drift alert triggers retraining script
- New model trains and enters promotion workflow
- Promoted model updates serving layer

---

## Running Phase 4

### Prerequisites
```bash
# Ensure all previous phases completed
# Phase 1: Data split in database
# Phase 2: Trained model in MLflow
# Phase 3: Model promoted to Production stage

# Install dependencies
pip install -r serving/requirements.txt

# Start full stack
docker-compose -f docker/docker-compose.yaml up -d

# Verify services
docker-compose -f docker/docker-compose.yaml ps
```

### Launch Serving Application
```bash
# Option 1: Direct execution
python serving/serving_app.py

# Option 2: Docker container
docker-compose -f docker/docker-compose.yaml up serving -d

# Verify serving is ready
curl http://localhost:8000/health
```

### Test Inference
```bash
# Single prediction
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "This product is amazing!"}'

# Response:
# {
#   "request_id": "abc123...",
#   "prediction": "positive",
#   "confidence": 0.95,
#   "latency_ms": 45.2,
#   "model_version": "v2",
#   "timestamp": "2024-01-15T10:30:00Z"
# }
```

### Generate Inference Load & Monitor Drift
```bash
# Generate predictions to accumulate inference logs
for i in {1..200}; do
  curl -X POST http://localhost:8000/predict \
    -H "Content-Type: application/json" \
    -d '{"text": "Sample review text here"}'
done

# Check inference statistics
curl http://localhost:8000/inference/stats?window_minutes=60

# Check alerts
psql -h localhost -U postgres -d mlops -c \
  "SELECT * FROM monitoring_alerts WHERE alert_type = 'drift' ORDER BY triggered_at DESC LIMIT 5;"
```

### Test Drift Detection Scenario
```bash
# Simulate distribution shift by sending very different text
for i in {1..100}; do
  curl -X POST http://localhost:8000/predict \
    -H "Content-Type: application/json" \
    -d '{"text": "UNUSUAL VERY LONG TEXT WITH SPECIAL CHARACTERS !@#$%^&*()_+ TO TRIGGER DRIFT DETECTION"}'
done

# Observe: Drift alert generated and logged
psql -h localhost -U postgres -d mlops -c \
  "SELECT severity, message, triggered_at FROM monitoring_alerts ORDER BY triggered_at DESC LIMIT 5;"
```

### View Monitoring Data
```bash
# Recent inferences
psql -h localhost -U postgres -d mlops -c \
  "SELECT timestamp, prediction, confidence, latency_ms FROM inference_logs ORDER BY timestamp DESC LIMIT 10;"

# Alerts
psql -h localhost -U postgres -d mlops -c \
  "SELECT alert_type, severity, message FROM monitoring_alerts ORDER BY triggered_at DESC LIMIT 10;"

# Statistics
curl http://localhost:8000/inference/stats?window_minutes=60 | jq .
```

---

## Key Concepts Introduced

1. **REST API Design**: Request validation, error handling, async operations
2. **Production Monitoring**: Real-time performance tracking and alerting
3. **Statistical Testing**: KS-Test and PSI for drift detection
4. **Closed-Loop ML**: Automated retraining triggered by production issues
5. **Containerization**: Docker for reproducible deployment

---

## Common Issues

| Issue | Solution |
|-------|----------|
| `Connection refused: serving cannot reach database` | Check PostgreSQL running; check network config in docker-compose |
| `Model fails to load from MLflow` | Verify model promoted to Production stage in Phase 3 |
| `Drift alerts never triggered` | Check baseline distribution loaded; may need more inferences to detect shift |
| `High latency in predictions` | Check GPU availability; reduce model size or batch process |

---

## Acceptance Checklist

- [ ] API server starts and serves requests < 100ms
- [ ] Can make predictions via REST API
- [ ] All inferences logged to database
- [ ] Health check endpoint responds
- [ ] Drift detection triggers on simulated shift
- [ ] Alerts generated and logged
- [ ] Docker container builds and runs
- [ ] Full stack (database, MLflow, serving) runs via docker-compose

---

## System Complete!

Congratulations! You have now built a complete, production-grade MLOps system with:
- ✓ **Data Infrastructure**: Automated ingestion with validation (Phase 1)
- ✓ **Continuous Training**: Reproducible model training with MLflow (Phase 2)
- ✓ **Model Registry**: Automated promotion with safety gates (Phase 3)
- ✓ **Production Serving**: REST API with drift detection (Phase 4)

### What's Next?
- **Monitor Production**: Collect inference data and analyze trends
- **Improve Models**: Use drift and performance alerts to drive iterations
- **Scale**: Adapt patterns to larger datasets and more complex models
- **Cloud Deployment**: Deploy to AWS/GCP/Azure using same containerization patterns
- **Advanced Features**:
  - Feature store for centralized feature management
  - Explainability (SHAP, LIME) for model interpretability
  - A/B testing for gradual model rollout
  - Federated learning for distributed training
  - AutoML for automated hyperparameter tuning

---

## Production Deployment Patterns

### Pattern 1: Blue-Green Deployment
```
Production (Blue)  → Still serving requests
New Model (Green)  → In staging, receiving shadow traffic
→ Switch traffic to Green when validated
→ Keep Blue as rollback target
```

### Pattern 2: Canary Deployment
```
Production (90%)  → 90% traffic to stable model
Canary (10%)      → 10% traffic to new model
→ Monitor canary metrics
→ Gradually increase traffic if healthy
→ Rollback if issues detected
```

### Pattern 3: Multi-Armed Bandit
```
Model A (exploratory)
Model B (exploit best)
Model C (explore new)
→ Route traffic based on performance
→ Maximize cumulative reward
```

Choose based on your use case and risk tolerance!
