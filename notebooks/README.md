# Jupyter Notebooks - Exploratory Analysis & Learning

This directory contains Jupyter notebooks for interactive exploration of the MLOps system.

## Notebooks (To Be Created)

### Phase 1: Data Exploration
- `01_explore_raw_data.ipynb` - Load and explore raw data
- `02_validation_analysis.ipynb` - Analyze validation results
- `03_data_quality_report.ipynb` - Generate data quality metrics

### Phase 2: Training Analysis
- `04_mlflow_experiment_tracking.ipynb` - Query and compare training runs
- `05_model_performance_analysis.ipynb` - Analyze model metrics
- `06_hyperparameter_tuning_analysis.ipynb` - Visualize hyperparameter impacts

### Phase 3: Model Registry
- `07_promotion_history.ipynb` - Track promotion decisions over time
- `08_model_comparison.ipynb` - Compare different model versions

### Phase 4: Production Monitoring
- `09_inference_analysis.ipynb` - Analyze inference logs
- `10_drift_monitoring.ipynb` - Visualize drift detection events
- `11_alert_analysis.ipynb` - Analyze alert triggers and patterns

## Quick Start

```bash
# Ensure Jupyter is installed
pip install jupyter notebook

# Start Jupyter server
jupyter notebook

# Open http://localhost:8888 in browser

# Navigate to notebooks/ directory
```

## Template Structure

Each notebook should include:
1. **Setup** - Import libraries, connect to database/MLflow
2. **Exploration** - Load and explore data
3. **Analysis** - Calculate metrics and visualizations
4. **Insights** - Key findings and recommendations

## Common Queries

### Query recent training runs
```python
import mlflow

runs = mlflow.search_runs(
    experiment_names=['sentiment-classifier-v1'],
    order_by=['start_time DESC'],
    max_results=5
)
runs.to_pandas()[['run_id', 'params.learning_rate', 'metrics.f1']]
```

### Query inference logs
```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql://postgres:postgres@localhost:5432/mlops")
df = pd.read_sql("SELECT * FROM inference_logs LIMIT 100", engine)
```

### Query alerts
```sql
SELECT 
    alert_type, 
    severity, 
    COUNT(*) as count,
    MAX(triggered_at) as latest
FROM monitoring_alerts
GROUP BY alert_type, severity
ORDER BY triggered_at DESC;
```

## Running in Docker

```bash
# If using docker-compose
docker-compose -f docker/docker-compose.yaml up jupyter -d

# Access at http://localhost:8888
```

## Tips

- Use markdown cells to document your analysis
- Save important visualizations as PNG
- Export analysis as HTML reports
- Use `# TODO` comments for incomplete sections

See [docs/PHASES.md](../docs/PHASES.md) for more context on each phase.
