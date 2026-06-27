# 📚 Documentation Index & Navigation Guide

Welcome to the **MLOps Learning Module**! This document helps you navigate all available resources.

## 🎯 Start Here

**New to this project?** Follow this order:

1. **[README.md](README.md)** (5 min) - Project overview & quick start
2. **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** (10 min) - System design
3. **[scripts/quickstart.sh](scripts/quickstart.sh) or [quickstart.bat](scripts/quickstart.bat)** (5 min) - Setup environment
4. **[data/README.md](data/README.md)** (15 min) - Begin Phase 1

---

## 📖 Documentation Map

### Project Overview (START HERE)
| Document | Purpose | Read Time |
|----------|---------|-----------|
| [README.md](README.md) | Main entry point, project scope, quick start | 10 min |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | Comprehensive project overview & statistics | 15 min |
| [COMPLETION_CHECKLIST.md](COMPLETION_CHECKLIST.md) | What's complete, what's stubbed, status | 10 min |
| [DEVELOPMENT.md](DEVELOPMENT.md) | Developer guide, patterns, common issues | 20 min |

### System Design & Architecture
| Document | Purpose | Read Time |
|----------|---------|-----------|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | System design, data flow, database schema | 15 min |
| [docs/SETUP.md](docs/SETUP.md) | Environment setup, Docker, troubleshooting | 15 min |
| [docs/PHASES.md](docs/PHASES.md) | **KEY**: All 24 tasks with acceptance criteria | 30 min |
| [.env.example](.env.example) | Environment variable reference | 5 min |

### Implementation Guides (Phase-by-Phase)
| Phase | Document | Tasks | Time |
|-------|----------|-------|------|
| 1: Data | [data/README.md](data/README.md) | 1.1-1.5 | 8-12 hours |
| 2: Training | [training/README.md](training/README.md) | 2.1-2.6 | 10-15 hours |
| 3: Registry | [registry/README.md](registry/README.md) | 3.1-3.6 | 10-12 hours |
| 4: Serving | [serving/README.md](serving/README.md) | 4.1-4.7 | 12-16 hours |

### Utility Documentation
| Component | Document | Purpose |
|-----------|----------|---------|
| Notebooks | [notebooks/README.md](notebooks/README.md) | Jupyter exploration templates |
| MLflow | [mlflow/README.md](mlflow/README.md) | MLflow configuration |
| Config | [config/](config/) | YAML + SQL configuration files |

---

## 🔍 Find What You Need

### "I want to..."

#### Understand the System
- **Understand overall architecture** → [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- **See all tasks and deliverables** → [docs/PHASES.md](docs/PHASES.md)
- **Get project statistics** → [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
- **Know what's complete** → [COMPLETION_CHECKLIST.md](COMPLETION_CHECKLIST.md)

#### Set Up My Environment
- **Quick setup (5 min)** → Run `scripts/quickstart.bat` (Windows) or `bash scripts/quickstart.sh` (Mac/Linux)
- **Manual setup** → [docs/SETUP.md](docs/SETUP.md)
- **Troubleshoot issues** → [docs/SETUP.md#troubleshooting](docs/SETUP.md) or [DEVELOPMENT.md](DEVELOPMENT.md)

#### Implement Phase 1 (Data)
1. Read [data/README.md](data/README.md) - overview of 5 tasks
2. Review [config/database_schema.sql](config/database_schema.sql) - understand data model
3. Review [config/validation_rules.yaml](config/validation_rules.yaml) - understand validation rules
4. Start with [data/db_utils.py](data/db_utils.py) - implement DatabaseConnector
5. Reference [docs/PHASES.md](docs/PHASES.md) - Task 1.1-1.5 details

#### Implement Phase 2 (Training)
1. Read [training/README.md](training/README.md) - overview of 6 tasks
2. Review [config/training_config.yaml](config/training_config.yaml) - hyperparameters
3. Start with [training/model_wrapper.py](training/model_wrapper.py) - model setup
4. Then [training/metrics_calculator.py](training/metrics_calculator.py) - metrics
5. Reference [docs/PHASES.md](docs/PHASES.md) - Task 2.1-2.6 details

#### Implement Phase 3 (Registry)
1. Read [registry/README.md](registry/README.md) - overview of 6 tasks
2. Review [config/promotion_rules.yaml](config/promotion_rules.yaml) - promotion gates
3. Start with [registry/promotion_pipeline.py](registry/promotion_pipeline.py)
4. Reference [docs/PHASES.md](docs/PHASES.md) - Task 3.1-3.6 details

#### Implement Phase 4 (Serving)
1. Read [serving/README.md](serving/README.md) - overview of 7 tasks
2. Review [config/alert_rules.yaml](config/alert_rules.yaml) - monitoring rules
3. Start with [serving/serving_app.py](serving/serving_app.py) - REST API
4. Then [serving/drift_monitor.py](serving/drift_monitor.py) - drift detection
5. Reference [docs/PHASES.md](docs/PHASES.md) - Task 4.1-4.7 details

#### Learn Development Patterns
- **Python patterns & examples** → [DEVELOPMENT.md](DEVELOPMENT.md)
- **Code organization** → [DEVELOPMENT.md#project-structure](DEVELOPMENT.md)
- **Testing strategy** → [DEVELOPMENT.md#testing-strategy](DEVELOPMENT.md)
- **Common pitfalls** → [DEVELOPMENT.md#common-pitfalls-to-avoid](DEVELOPMENT.md)
- **Debugging tips** → [DEVELOPMENT.md#debugging-tips](DEVELOPMENT.md)

#### Debug Issues
- **Setup/Docker issues** → [docs/SETUP.md#troubleshooting](docs/SETUP.md)
- **Code implementation issues** → [DEVELOPMENT.md#debugging-tips](DEVELOPMENT.md)
- **Database issues** → [DEVELOPMENT.md#debugging-tips](DEVELOPMENT.md)
- **MLflow issues** → [DEVELOPMENT.md#debugging-tips](DEVELOPMENT.md)

---

## 📁 File Organization

```
learn-MLOps/
├── 📖 README.md                       # START: Project overview
├── 📖 PROJECT_SUMMARY.md              # Comprehensive summary
├── 📖 DEVELOPMENT.md                  # Developer guide
├── 📖 COMPLETION_CHECKLIST.md         # Implementation status
│
├── 📚 docs/
│   ├── ARCHITECTURE.md                # System design
│   ├── SETUP.md                       # Environment setup
│   ├── PHASES.md                      # All 24 tasks
│   └── README.md                      # Docs index
│
├── ⚙️  config/
│   ├── database_schema.sql
│   ├── training_config.yaml
│   ├── promotion_rules.yaml
│   ├── validation_rules.yaml
│   └── alert_rules.yaml
│
├── 🐍 data/                           # Phase 1: Data Infrastructure
│   ├── README.md                      # Phase 1 guide
│   ├── db_utils.py
│   └── scripts/
│       └── generate_sample_data.py
│
├── 🎓 training/                       # Phase 2: Continuous Training
│   ├── README.md                      # Phase 2 guide
│   ├── model_wrapper.py
│   ├── metrics_calculator.py
│   ├── requirements.txt
│   └── tests/
│
├── 📊 registry/                       # Phase 3: Model Registry
│   ├── README.md                      # Phase 3 guide
│   ├── promotion_pipeline.py
│   └── tests/
│
├── 🚀 serving/                        # Phase 4: Production Serving
│   ├── README.md                      # Phase 4 guide
│   ├── serving_app.py
│   ├── drift_monitor.py
│   ├── requirements.txt
│   └── tests/
│
├── 🐳 docker/
│   ├── docker-compose.yaml
│   ├── Dockerfile.mlflow
│   └── Dockerfile.serving
│
├── 📜 scripts/
│   ├── quickstart.sh
│   └── quickstart.bat
│
└── 🎯 Other
    ├── .env.example
    ├── .gitignore
    ├── mlflow/README.md
    └── notebooks/README.md
```

---

## 🗂️ Quick Reference by Document Type

### Configuration Files
- **Database Schema**: [config/database_schema.sql](config/database_schema.sql)
- **Training Config**: [config/training_config.yaml](config/training_config.yaml)
- **Promotion Rules**: [config/promotion_rules.yaml](config/promotion_rules.yaml)
- **Validation Rules**: [config/validation_rules.yaml](config/validation_rules.yaml)
- **Alert Rules**: [config/alert_rules.yaml](config/alert_rules.yaml)
- **Environment Variables**: [.env.example](.env.example)

### Python Implementation Files
- **Phase 1 - Data**: [data/db_utils.py](data/db_utils.py) + [data/scripts/generate_sample_data.py](data/scripts/generate_sample_data.py)
- **Phase 2 - Training**: [training/model_wrapper.py](training/model_wrapper.py) + [training/metrics_calculator.py](training/metrics_calculator.py)
- **Phase 3 - Registry**: [registry/promotion_pipeline.py](registry/promotion_pipeline.py)
- **Phase 4 - Serving**: [serving/serving_app.py](serving/serving_app.py) + [serving/drift_monitor.py](serving/drift_monitor.py)

### Setup & Infrastructure
- **Quick Start**: [scripts/quickstart.sh](scripts/quickstart.sh) or [scripts/quickstart.bat](scripts/quickstart.bat)
- **Docker**: [docker/docker-compose.yaml](docker/docker-compose.yaml)
- **Setup Guide**: [docs/SETUP.md](docs/SETUP.md)

### Task Breakdown
- **All Tasks**: [docs/PHASES.md](docs/PHASES.md)
- **Phase 1 Tasks**: [data/README.md](data/README.md)
- **Phase 2 Tasks**: [training/README.md](training/README.md)
- **Phase 3 Tasks**: [registry/README.md](registry/README.md)
- **Phase 4 Tasks**: [serving/README.md](serving/README.md)

---

## 🎓 Learning Paths

### Path 1: Complete Beginner (Recommended)
1. [README.md](README.md) - understand project
2. [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - learn system design
3. Run quickstart script - set up environment
4. [data/README.md](data/README.md) - implement Phase 1
5. [training/README.md](training/README.md) - implement Phase 2
6. [registry/README.md](registry/README.md) - implement Phase 3
7. [serving/README.md](serving/README.md) - implement Phase 4

**Time**: 40-55 hours  
**Outcome**: Full understanding of MLOps lifecycle

### Path 2: Experienced MLOps Engineer
1. [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) - system design
2. [docs/PHASES.md](docs/PHASES.md) - task details
3. Review config files - understand rules & thresholds
4. Focus on Phases 3 & 4 - advanced topics
5. [DEVELOPMENT.md](DEVELOPMENT.md) - patterns & practices

**Time**: 15-20 hours  
**Outcome**: Reference architecture for your own projects

### Path 3: Learning Specific Phase
Pick any phase and follow:
1. Phase-specific README
2. [docs/PHASES.md](docs/PHASES.md) - detailed tasks
3. Review related config files
4. Implement code stubs
5. Test and validate

**Time**: Phase-dependent (8-16 hours)

---

## 🔗 External Resources

### Primary Technologies
- [MLflow Documentation](https://mlflow.org/docs/latest/)
- [FastAPI Tutorial](https://fastapi.tiangolo.com/tutorial/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [PyTorch Documentation](https://pytorch.org/docs/)
- [HuggingFace Transformers](https://huggingface.co/docs/transformers/)

### Concepts & Patterns
- [MLOps Principles](https://ml-ops.systems/)
- [Drift Detection](https://en.wikipedia.org/wiki/Statistical_hypothesis_testing)
- [Transfer Learning](https://en.wikipedia.org/wiki/Transfer_learning)
- [REST API Design](https://restfulapi.net/)

---

## ✅ Verification Checklist

After reading documentation:
- [ ] Understand 4-phase architecture
- [ ] Know what each phase does
- [ ] Can explain data flow through system
- [ ] Understand database schema (6 tables)
- [ ] Know how to run quickstart script
- [ ] Understand promotion rules and safety gates
- [ ] Know what drift detection is
- [ ] Ready to implement Phase 1

---

## 💬 Have Questions?

1. **Check relevant phase README** (e.g., data/README.md)
2. **Search docstrings** in Python files (they explain what to implement)
3. **Review DEVELOPMENT.md** for patterns and examples
4. **Check docs/PHASES.md** for detailed task descriptions
5. **Read config files** to understand rules and thresholds

---

**Next Step**: Start with [README.md](README.md) → [scripts/quickstart.*](scripts/) → [data/README.md](data/README.md)

Good luck! 🚀
