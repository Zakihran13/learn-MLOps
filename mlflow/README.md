# MLflow Server Configuration & Management

This directory contains MLflow configuration and utilities for experiment tracking and model registry.

## Files

- `mlflow_config.py` - MLflow backend and artifact store configuration
- `mlflow_utils.py` - Utility functions for MLflow operations

## Quick Start

```bash
# Start MLflow UI server (already running via docker-compose)
docker-compose -f docker/docker-compose.yaml up mlflow -d

# Access MLflow UI
open http://localhost:5000
```

## MLflow Backend Configuration

- **Tracking URI**: `sqlite:///mlflow/mlflow.db` (local SQLite backend)
- **Artifact Store**: `./mlruns` (local directory)

For production deployments, use PostgreSQL backend:
```
postgresql://user:password@host:5432/mlflow_db
```

## See Also

- [MLflow Documentation](https://mlflow.org/docs/latest/)
- [Phase 2: Continuous Training README](../training/README.md)
