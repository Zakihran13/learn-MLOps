# Phase 2: Continuous Training Infrastructure & MLflow Automation

## Overview

Phase 2 automates model training with **MLflow experiment tracking**, converting validated data into production-ready models. This phase emphasizes reproducibility, metric logging, and artifact management.

## Directory Structure

```
training/
├── model_wrapper.py           # Model loading, fine-tuning, inference
├── metrics_calculator.py       # F1, precision, recall, latency calculations
├── train.py                    # Main training orchestration script
├── seed_manager.py            # Reproducibility utilities
├── requirements.txt           # Python dependencies ✓ (Created)
└── tests/
    ├── test_model_wrapper.py
    ├── test_metrics.py
    └── fixtures/
        └── sample_model.pt
```

## Tasks (2.1 - 2.6)

### Task 2.1: MLflow Tracking Server Setup
**Objective:** Configure MLflow server with local SQLite backend and artifact storage.

**Files to Complete:**
- `mlflow/mlflow_config.py` (New stub)
- Use existing `docker/docker-compose.yaml` ✓

**Implementation Steps:**
1. Create `mlflow/mlflow_config.py`:
   - Define MLflow tracking URI (local backend store)
   - Set artifact repository location
   - Experiment and run naming conventions

2. Start MLflow server:
   ```bash
   # Via Docker (already in docker-compose.yaml)
   docker-compose -f docker/docker-compose.yaml up mlflow -d
   
   # Verify: Open http://localhost:5000
   ```

3. Verify setup:
   - MLflow UI accessible at `http://localhost:5000`
   - Create test experiment via API

**Success Criteria:**
- MLflow UI loads and shows no experiments initially
- Can create experiment via `mlflow.set_experiment()`
- Artifacts directory exists at configured location

---

### Task 2.2: Model Wrapper & Transfer Learning
**Objective:** Implement model loading, layer freezing, and fine-tuning interface.

**Files to Complete:**
- `training/model_wrapper.py` → Complete all methods
- `config/training_config.yaml` ✓ (Created)

**Implementation Steps:**
1. Complete `ModelWrapper` class:
   - `load()` - Load distilBERT from HuggingFace
   - `freeze_layers(num_freeze)` - Freeze first N transformer layers
   - `get_optimizer()` - Create AdamW optimizer with L2 regularization
   - `forward()` - Forward pass returning logits
   - `predict()` - Single-sample inference
   - `save()` / `load_checkpoint()` - State management

2. Implement `TokenizationHelper`:
   - Batch tokenization with padding/truncation
   - Move tensors to device (CPU/GPU)

3. Test transfer learning setup:
   - Load model, freeze 8 layers, fine-tune final 2 layers
   - Verify gradient flow only in unfrozen layers

**Success Criteria:**
- Model loads from HuggingFace without errors
- Layer freezing prevents backprop in frozen layers
- Can execute forward pass on 32-token sample batch
- Model weights are saveable and loadable

---

### Task 2.3: Training Script with MLflow Logging
**Objective:** Create automated training loop that logs all metrics, parameters, and artifacts.

**Files to Complete:**
- `training/train.py` (New stub)
- Uses `model_wrapper.py`, `metrics_calculator.py`, database connection

**Implementation Steps:**
1. Create `training/train.py`:
   - Load training/validation data from database
   - Initialize MLflow run with experiment name
   - Set training parameters as MLflow params (learning_rate, epochs, etc)
   - Training loop:
     - Forward pass on batch
     - Compute loss (CrossEntropyLoss)
     - Backward pass and optimizer step
     - Log metrics every N steps (loss, accuracy, batch_time)
   - Validation loop every epoch:
     - Compute F1, precision, recall, ROC-AUC
     - Log metrics to MLflow
     - Save checkpoint if validation F1 improved
   - After training:
     - Save final model to MLflow artifacts
     - Log training time and data size
     - Save metrics summary JSON

2. CLI interface:
   ```bash
   python training/train.py \
       --config config/training_config.yaml \
       --output models/trained_model \
       --experiment sentiment-classifier-v1
   ```

**Success Criteria:**
- Training runs for 3 epochs on sample data
- MLflow run recorded with all parameters and metrics
- Model artifact saved and downloadable via UI
- Validation metrics improve or plateau (not random noise)

---

### Task 2.4: Comprehensive Metrics Calculation
**Objective:** Calculate F1, precision, recall, ROC-AUC, and latency statistics.

**Files to Complete:**
- `training/metrics_calculator.py` → Complete all methods

**Implementation Steps:**
1. Complete `MetricsCalculator`:
   - `compute_metrics()` - Calculate F1 (weighted), precision, recall, ROC-AUC
   - `compute_per_class_metrics()` - Per-class breakdown
   - `compute_latency_stats()` - p50, p95, p99 percentiles

2. Implement `ValidationMetricsLogger`:
   - Log metrics to MLflow with step tracking
   - Save confusion matrix as artifact
   - Save classification report as artifact

3. Implement `MetricsValidator`:
   - Compare computed metrics against thresholds
   - Return pass/fail and list of failures

**Success Criteria:**
- Metrics correctly calculated for binary classification
- Latency stats computed from inference times
- All metrics logged to MLflow and visible in UI
- Validation correctly identifies when metrics fall below threshold

---

### Task 2.5: Experiment Tracking & Run Management
**Objective:** Organize training runs and enable comparison of different hyperparameter configurations.

**Files to Complete:**
- `training/experiment_manager.py` (New stub)

**Implementation Steps:**
1. Create `training/experiment_manager.py`:
   - `ExperimentManager` class to:
     - Create/retrieve experiments by name
     - Track multiple runs within experiment
     - Compare runs (parameter and metric comparison)
     - Export run data for analysis

2. Support comparison queries:
   - Get best run by metric (highest F1)
   - Get runs with specific parameter values
   - Get run history for hyperparameter tuning

**Success Criteria:**
- Multiple runs tracked in single experiment
- Can compare runs in MLflow UI
- Export run data to CSV

---

### Task 2.6: Reproducibility & Seed Management
**Objective:** Ensure training is reproducible with fixed random seeds.

**Files to Complete:**
- `training/seed_manager.py` (New stub)

**Implementation Steps:**
1. Create `training/seed_manager.py`:
   - `set_seed(seed: int)` function to:
     - Set `random.seed(seed)`
     - Set `np.random.seed(seed)`
     - Set `torch.manual_seed(seed)`
     - Set `torch.backends.cudnn.deterministic = True`
     - Log seed value and timestamp

2. Call at training start:
   ```python
   from training.seed_manager import set_seed
   set_seed(42)
   ```

3. Document in training config:
   - Seed value in `training_config.yaml`
   - Log seed and date to MLflow

**Success Criteria:**
- Running training twice with same seed produces identical metrics
- Seed logged to MLflow run
- Training is reproducible across environments

---

## Running Phase 2

### Prerequisites
```bash
# Install dependencies
pip install -r training/requirements.txt

# Ensure Phase 1 completed: data is in database
python data/scripts/split_data.py --split_version v1.0

# Start MLflow server
docker-compose -f docker/docker-compose.yaml up mlflow -d
sleep 5
```

### Execute Training
```bash
# Single training run
python training/train.py \
    --config config/training_config.yaml \
    --split_version v1.0 \
    --output models/v1

# Compare hyperparameters by running multiple times:
python training/train.py --config config/training_config.yaml --learning_rate 1e-5
python training/train.py --config config/training_config.yaml --learning_rate 2e-5
python training/train.py --config config/training_config.yaml --learning_rate 5e-5

# View in MLflow UI: http://localhost:5000
```

### Verify Outputs
```bash
# Check MLflow run
curl http://localhost:5000/api/2.0/mlflow/runs/list \
    -H "Content-Type: application/json"

# Check saved model
ls models/v1/

# Check metrics logged
mlflow run --version 1.0 | grep "f1"
```

---

## Key Concepts Introduced

1. **MLflow Tracking**: Automatic logging of hyperparameters, metrics, and artifacts
2. **Transfer Learning**: Fine-tuning pre-trained model for domain-specific task
3. **Layer Freezing**: Reducing training time by freezing base model weights
4. **Experiment Tracking**: Organizing runs and enabling systematic hyperparameter tuning
5. **Reproducibility**: Fixed seeds ensure deterministic training

---

## Common Issues

| Issue | Solution |
|-------|----------|
| `ModuleNotFoundError: No module named 'transformers'` | Run `pip install -r training/requirements.txt` |
| `MLflow not found` | Start MLflow server: `docker-compose up mlflow -d` |
| `CUDA out of memory` | Reduce batch_size in training_config.yaml |
| `Training metrics are NaN` | Check learning rate; might be too high |

---

## Acceptance Checklist

- [ ] Model loads from HuggingFace successfully
- [ ] Training loop runs for 3 epochs without errors
- [ ] All metrics logged to MLflow and visible in UI
- [ ] F1-score on validation set is > 0.7
- [ ] Training produces consistent results with fixed seed
- [ ] Model artifacts saved and downloadable
- [ ] Training time < 10 minutes on CPU (for demo)

---

## Next Phase
Once Phase 2 completes, proceed to **Phase 3: Model Registry, Versioning, and Promotion Logic**.

The trained model from this phase is registered in the MLflow Model Registry in Phase 3.
