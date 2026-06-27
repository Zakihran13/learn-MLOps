@echo off
REM Quick Start Script for MLOps Learning Module (Windows)
REM Usage: scripts\quickstart.bat

setlocal enabledelayedexpansion

echo.
echo.
echo 🚀 MLOps Learning Module - Quick Start
echo =======================================
echo.

REM Step 1: Environment check
echo Step 1: Checking environment...
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed. Please install Docker from https://www.docker.com
    exit /b 1
)
echo ✓ Docker found

python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed. Please install Python 3.10+
    exit /b 1
)
echo ✓ Python found: 
python --version

REM Step 2: Create virtual environment
echo.
echo Step 2: Setting up Python virtual environment...
if not exist "venv" (
    python -m venv venv
    echo ✓ Virtual environment created
) else (
    echo ✓ Virtual environment already exists
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Step 3: Install dependencies
echo.
echo Step 3: Installing Python dependencies...
python -m pip install --upgrade pip setuptools wheel >nul 2>&1
pip install -q -r training\requirements.txt
echo ✓ Dependencies installed

REM Step 4: Start Docker containers
echo.
echo Step 4: Starting Docker containers (PostgreSQL, pgAdmin, MLflow)...
docker-compose -f docker\docker-compose.yaml up -d
echo Waiting for containers to start...
timeout /t 10 /nobreak >nul
echo ✓ Containers started

REM Step 5: Initialize database
echo.
echo Step 5: Initializing PostgreSQL database...
docker exec mlops-postgres psql -U postgres -f /config/database_schema.sql >nul 2>&1
if errorlevel 1 (
    echo ⚠ Database init attempted (may already be initialized^)
) else (
    echo ✓ Database initialized
)

REM Step 6: Generate sample data
echo.
echo Step 6: Generating sample training data...
if not exist "data\raw" mkdir data\raw
if not exist "logs" mkdir logs
python data\scripts\generate_sample_data.py --n_samples 1000 --output data\raw\sample_data.jsonl --positive_ratio 0.5
echo ✓ Sample data generated

REM Step 7: Print useful URLs
echo.
echo Step 7: Services ready!
echo.
echo Available Services:
echo   📊 MLflow UI:        http://localhost:5000
echo   🗄️  pgAdmin:          http://localhost:5050
echo   📝 PostgreSQL:        localhost:5432 (user: postgres, password: postgres)
echo   🤖 API Server:        http://localhost:8000 (after Phase 4 implementation)
echo.

REM Step 8: Print next steps
echo 📚 Next Steps:
echo   1. Read Phase 1 implementation guide: data\README.md
echo   2. Implement data ingestion and validation
echo   3. Run: python data\scripts\ingest_data.py --input data\raw\sample_data.jsonl
echo   4. Check database: psql -h localhost -U postgres -d mlops
echo.

echo ✨ Setup Complete!
echo.
echo For help, see:
echo   • README.md - Project overview
echo   • docs\ARCHITECTURE.md - System design
echo   • docs\PHASES.md - Complete 24-task checklist
echo.
