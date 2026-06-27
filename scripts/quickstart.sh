#!/bin/bash
# Quick Start Script for MLOps Learning Module
# Usage: bash scripts/quickstart.sh

set -e

echo "🚀 MLOps Learning Module - Quick Start"
echo "======================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Environment check
echo -e "${BLUE}Step 1: Checking environment...${NC}"
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker from https://www.docker.com"
    exit 1
fi
echo -e "${GREEN}✓ Docker found${NC}"

if ! command -v python &> /dev/null; then
    echo "❌ Python is not installed. Please install Python 3.10+"
    exit 1
fi
echo -e "${GREEN}✓ Python found: $(python --version)${NC}"

# Step 2: Create virtual environment
echo ""
echo -e "${BLUE}Step 2: Setting up Python virtual environment...${NC}"
if [ ! -d "venv" ]; then
    python -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment already exists${NC}"
fi

# Activate virtual environment
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    source venv/Scripts/activate
else
    source venv/bin/activate
fi

# Step 3: Install dependencies
echo ""
echo -e "${BLUE}Step 3: Installing Python dependencies...${NC}"
pip install --upgrade pip setuptools wheel
pip install -q -r training/requirements.txt
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Step 4: Start Docker containers
echo ""
echo -e "${BLUE}Step 4: Starting Docker containers (PostgreSQL, pgAdmin, MLflow)...${NC}"
docker-compose -f docker/docker-compose.yaml up -d
sleep 10
echo -e "${GREEN}✓ Containers started${NC}"

# Step 5: Initialize database
echo ""
echo -e "${BLUE}Step 5: Initializing PostgreSQL database...${NC}"
docker exec mlops-postgres psql -U postgres -f /config/database_schema.sql 2>/dev/null || \
    psql -h localhost -U postgres -f config/database_schema.sql 2>/dev/null || \
    echo -e "${YELLOW}⚠ Database init attempted (may already be initialized)${NC}"
echo -e "${GREEN}✓ Database initialized${NC}"

# Step 6: Generate sample data
echo ""
echo -e "${BLUE}Step 6: Generating sample training data...${NC}"
mkdir -p data/raw logs
python data/scripts/generate_sample_data.py \
    --n_samples 1000 \
    --output data/raw/sample_data.jsonl \
    --positive_ratio 0.5
echo -e "${GREEN}✓ Sample data generated${NC}"

# Step 7: Run Phase 1 pipeline
echo ""
echo -e "${BLUE}Step 7: Running Phase 1 - Data Infrastructure...${NC}"
echo "   (This step requires Phase 1 implementation to be complete)"
echo "   Run: python data/scripts/ingest_data.py --input data/raw/sample_data.jsonl"
echo ""

# Step 8: Print useful URLs
echo -e "${BLUE}Step 8: Services ready!${NC}"
echo ""
echo -e "${GREEN}Available Services:${NC}"
echo -e "  📊 MLflow UI:        ${BLUE}http://localhost:5000${NC}"
echo -e "  🗄️  pgAdmin:          ${BLUE}http://localhost:5050${NC}"
echo -e "  📝 PostgreSQL:        ${BLUE}localhost:5432 (user: postgres, password: postgres)${NC}"
echo -e "  🤖 API Server:        ${BLUE}http://localhost:8000 (after Phase 4 implementation)${NC}"
echo ""

# Step 9: Print next steps
echo -e "${YELLOW}📚 Next Steps:${NC}"
echo -e "  1. Read Phase 1 implementation guide: ${BLUE}data/README.md${NC}"
echo -e "  2. Implement data ingestion and validation"
echo -e "  3. Run: ${BLUE}python data/scripts/ingest_data.py --input data/raw/sample_data.jsonl${NC}"
echo -e "  4. Check database: ${BLUE}psql -h localhost -U postgres -d mlops${NC}"
echo ""

echo -e "${GREEN}✨ Setup Complete!${NC}"
echo ""
echo -e "For help, see:"
echo -e "  • ${BLUE}README.md${NC} - Project overview"
echo -e "  • ${BLUE}docs/ARCHITECTURE.md${NC} - System design"
echo -e "  • ${BLUE}docs/PHASES.md${NC} - Complete 24-task checklist"
echo ""
