# Phase 3: Model Registry, Versioning, and Promotion Logic

## Overview

Phase 3 implements **model governance** through MLflow Model Registry, with strict programmatic promotion rules. Models are evaluated against production baseline before automatic promotion to Staging/Production stages.

## Directory Structure

```
registry/
├── promotion_pipeline.py        # Core promotion decision engine
├── comparison_engine.py         # Metrics comparison logic
├── model_validation_tests.py    # Validation test suite
├── rollback_script.py          # Emergency rollback mechanism
└── tests/
    ├── test_promotion_pipeline.py
    └── fixtures/
```

## Tasks (3.1 - 3.6)

### Task 3.1: Model Registry Setup & Baseline Registration
**Objective:** Initialize MLflow Model Registry and register initial production baseline.

**Files to Complete:**
- `registry/registry_setup.py` (New stub)
- Use existing `mlflow/mlflow_config.py`

**Implementation Steps:**
1. Create `registry/registry_setup.py`:
   - Create registered model "sentiment-classifier"
   - Register current best model as "Production" stage
   - Tag as "baseline-v1" for reference
   - Record baseline metrics for comparison

2. Execute setup:
   ```bash
   python registry/registry_setup.py \
       --model_name sentiment-classifier \
       --run_id <best_run_from_phase2>
   ```

3. Verify in MLflow UI:
   - Navigate to Models
   - See "sentiment-classifier" with Production stage

**Success Criteria:**
- Model registry shows "sentiment-classifier"
- Production stage points to baseline model
- Baseline metrics stored in database

---

### Task 3.2: Model Comparison Engine
**Objective:** Implement metric comparison logic for trained vs. baseline models.

**Files to Complete:**
- `registry/comparison_engine.py` (New stub)

**Implementation Steps:**
1. Create `registry/comparison_engine.py`:
   - `ComparisonEngine` class with:
     - `get_baseline_metrics()` - Fetch production model metrics
     - `get_candidate_metrics()` - Fetch new model metrics
     - `compare_f1()` - F1-score comparison with delta threshold
     - `compare_latency()` - Latency check
     - `compare_precision_recall()` - Individual metric checks

2. Implement comparison rules from `config/promotion_rules.yaml`:
   - F1 must be >= threshold OR >= (baseline - 2%)
   - Latency must be < 100ms
   - Precision and recall must meet thresholds

3. Return comprehensive comparison report:
   ```python
   {
       "f1": {"baseline": 0.80, "candidate": 0.81, "pass": True},
       "latency": {"baseline": 50, "candidate": 45, "pass": True},
       "overall": True,
       "recommendation": "promote"
   }
   ```

**Success Criteria:**
- Correctly identifies when model is better than baseline
- Correctly rejects model if metrics degrade > 2%
- Provides clear decision explanation

---

### Task 3.3: Validation Test Suite
**Objective:** Define and execute validation tests before promotion.

**Files to Complete:**
- `registry/model_validation_tests.py` (New stub)

**Implementation Steps:**
1. Create `registry/model_validation_tests.py`:
   - `ValidationTestSuite` class with multiple tests:
     - **Test 1: Inference Latency** - All predictions < 100ms
     - **Test 2: Output Validity** - Predictions are valid (0-1, valid labels)
     - **Test 3: Error Handling** - Model handles invalid input gracefully
     - **Test 4: Consistency** - Same input produces same output (3x)
     - **Test 5: Coverage** - Model handles all classes in dataset

2. Load test dataset (validation split from Phase 1):
   - Use 100-200 samples for validation
   - Mix of typical and edge-case inputs

3. Execute all tests:
   ```bash
   python registry/model_validation_tests.py \
       --model_version <version> \
       --model_name sentiment-classifier
   ```

4. Return pass/fail for each test

**Success Criteria:**
- All 5 tests defined and executable
- Model passes all tests on validation data
- Test results logged to MLflow

---

### Task 3.4: Promotion Pipeline Orchestration
**Objective:** Implement full promotion decision workflow.

**Files to Complete:**
- `registry/promotion_pipeline.py` → Complete all methods

**Implementation Steps:**
1. Complete `PromotionEngine` class:
   - `get_production_baseline()` - Fetch production model metrics
   - `compare_metrics()` - Run comparison engine
   - `validate_model()` - Run validation test suite
   - `promote_model()` - Transition stage in registry
   - `make_promotion_decision()` - Orchestrate full workflow

2. Decision logic (from `config/promotion_rules.yaml`):
   ```
   IF comparison PASSES AND validation PASSES:
       → Auto-promote to Staging
       → Require manual approval for Production
   ELSE:
       → Reject with detailed reason
   ```

3. Create promotion decision report:
   ```python
   {
       "decision": "promote",
       "target_stage": "Staging",
       "reason": "All metrics pass, validation successful",
       "metrics_comparison": {...},
       "validation_results": {...},
       "timestamp": "2024-01-15T10:30:00Z"
   }
   ```

4. Implement `PromotionAuditLog` to log all decisions to database

**Success Criteria:**
- Promotion workflow executes end-to-end
- Model correctly promoted when passing all checks
- Decision logged to audit table with full details

---

### Task 3.5: Automatic Model Versioning & Stage Transitions
**Objective:** Manage model versions and automate stage transitions.

**Files to Complete:**
- `registry/promotion_pipeline.py` → `ModelVersionManager` class

**Implementation Steps:**
1. Complete `ModelVersionManager`:
   - `register_model()` - Register new version after training
   - `get_model_versions()` - List all versions
   - `get_stage_model()` - Get current model in stage

2. Version tracking:
   - Auto-increment version numbers (v1, v2, v3...)
   - Track status for each version (Development, Staging, Production, Archived)

3. Transition rules:
   - New model → None (not in any stage)
   - After promotion → Staging
   - After manual approval → Production
   - When superseded → Archived

**Success Criteria:**
- Multiple model versions trackable
- Stage transitions occur correctly
- Version history preserved

---

### Task 3.6: Rollback Mechanism & Safety Gates
**Objective:** Implement emergency rollback for production incidents.

**Files to Complete:**
- `registry/rollback_script.py` (New stub)

**Implementation Steps:**
1. Create `registry/rollback_script.py`:
   - `RollbackManager` class with:
     - `rollback_to_previous()` - Revert to previous production version
     - `rollback_to_version(version)` - Revert to specific version
     - `get_rollback_options()` - List available versions to rollback to

2. Safety gates:
   - Require confirmation for rollback
   - Log all rollback events with reason
   - Notify on successful rollback
   - Update serving layer

3. CLI interface:
   ```bash
   python registry/rollback_script.py \
       --model_name sentiment-classifier \
       --to_version v1 \
       --reason "Performance degradation detected"
   ```

4. Auto-rollback trigger:
   - If production model F1 drops > 5% in 1 hour
   - If error rate > 5%
   - Automatic alert sent; requires manual confirmation

**Success Criteria:**
- Can rollback to any previous version
- Rollback logged with reason and timestamp
- Rollback updates Model Registry stage

---

## Running Phase 3

### Prerequisites
```bash
# Ensure Phase 2 completed: trained model in MLflow
# MLflow running: docker-compose up mlflow -d

# Load Phase 2 best model (get run_id from MLflow)
python registry/registry_setup.py --run_id <run_id_from_phase2>
```

### Execute Promotion Workflow
```bash
# Register new model from training run
python registry/promotion_pipeline.py register \
    --model_name sentiment-classifier \
    --run_id <latest_training_run>

# Evaluate for promotion
python registry/promotion_pipeline.py evaluate \
    --model_name sentiment-classifier \
    --model_version 2

# View decision
cat logs/promotion_decisions.json

# Manually promote if needed (after manual review)
python registry/promotion_pipeline.py promote \
    --model_name sentiment-classifier \
    --model_version 2 \
    --to_stage Production
```

### Test Rollback Scenario
```bash
# Simulate production issue and rollback
python registry/rollback_script.py \
    --model_name sentiment-classifier \
    --to_version v1 \
    --reason "Testing rollback mechanism"

# Verify rollback in MLflow UI
```

---

## Key Concepts Introduced

1. **Model Registry**: MLflow's model versioning and stage management system
2. **Automated Promotion**: Programmatic rules for safe model transitions
3. **Validation Gates**: Testing before production deployment
4. **Audit Trail**: Complete history of all promotion decisions
5. **Rollback Safety**: Emergency revert capability with logging

---

## Common Issues

| Issue | Solution |
|-------|----------|
| `ModelRegistryException: Model not found` | Ensure Phase 2 registered model; check name matches |
| `Comparison shows NaN values` | Verify baseline metrics were logged in Phase 2 |
| `Promotion rejected but should pass` | Check promotion_rules.yaml thresholds; may be too strict |
| `Cannot rollback: only 1 version` | Train and register additional versions first |

---

## Acceptance Checklist

- [ ] Model Registry initialized with baseline model
- [ ] Comparison engine correctly compares metrics
- [ ] All 5 validation tests passing
- [ ] Promotion workflow executes end-to-end
- [ ] Model correctly promoted to Staging when passing all checks
- [ ] Manual approval gate for Production stage working
- [ ] Rollback tested and functional
- [ ] All decisions logged to audit table

---

## Next Phase
Once Phase 3 completes, proceed to **Phase 4: Containerized Deployment, Production Serving, & Drift Detection**.

The promoted model from this phase is deployed for inference in Phase 4.
