-- MLOps PostgreSQL Database Schema
-- Initialize this script via: psql -U postgres < config/database_schema.sql

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS mlops;
\c mlops

-- Raw data from ingestion (unvalidated)
CREATE TABLE IF NOT EXISTS raw_data (
    id SERIAL PRIMARY KEY,
    ingestion_timestamp TIMESTAMP DEFAULT NOW(),
    source_file VARCHAR(255),
    features JSONB NOT NULL,
    raw_text TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_ingestion_time (ingestion_timestamp)
);

-- Validated data (passed quality checks)
CREATE TABLE IF NOT EXISTS validated_data (
    id SERIAL PRIMARY KEY,
    raw_data_id INTEGER REFERENCES raw_data(id) ON DELETE CASCADE,
    features JSONB NOT NULL,
    text_content TEXT,
    is_valid BOOLEAN DEFAULT TRUE,
    validation_errors JSONB,
    validated_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_valid_flag (is_valid)
);

-- Training split (60%)
CREATE TABLE IF NOT EXISTS train_split (
    id SERIAL PRIMARY KEY,
    validated_data_id INTEGER REFERENCES validated_data(id) ON DELETE CASCADE,
    split_version VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_split_version (split_version)
);

-- Validation split (20%)
CREATE TABLE IF NOT EXISTS val_split (
    id SERIAL PRIMARY KEY,
    validated_data_id INTEGER REFERENCES validated_data(id) ON DELETE CASCADE,
    split_version VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_split_version (split_version)
);

-- Test split (20%)
CREATE TABLE IF NOT EXISTS test_split (
    id SERIAL PRIMARY KEY,
    validated_data_id INTEGER REFERENCES validated_data(id) ON DELETE CASCADE,
    split_version VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_split_version (split_version)
);

-- Inference logs (every prediction)
CREATE TABLE IF NOT EXISTS inference_logs (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT NOW(),
    input_features JSONB NOT NULL,
    prediction VARCHAR(100),
    confidence FLOAT,
    model_version VARCHAR(50),
    inference_latency_ms INT,
    request_id VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_timestamp (timestamp),
    INDEX idx_model_version (model_version)
);

-- Monitoring and drift alerts
CREATE TABLE IF NOT EXISTS monitoring_alerts (
    id SERIAL PRIMARY KEY,
    alert_type VARCHAR(50),  -- 'drift', 'performance', 'error'
    severity VARCHAR(20),     -- 'LOW', 'MEDIUM', 'HIGH', 'CRITICAL'
    message TEXT,
    metrics JSONB,
    triggered_at TIMESTAMP DEFAULT NOW(),
    acknowledged BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_severity (severity),
    INDEX idx_triggered_time (triggered_at)
);

-- Audit logs
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(100),  -- 'ingestion', 'training', 'promotion', etc
    event_details JSONB,
    status VARCHAR(50),        -- 'success', 'failure', 'warning'
    error_message TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    INDEX idx_event_type (event_type),
    INDEX idx_status (status)
);

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;

-- Create indexes for common queries
CREATE INDEX idx_raw_source ON raw_data(source_file);
CREATE INDEX idx_validated_raw_id ON validated_data(raw_data_id);
CREATE INDEX idx_inference_model ON inference_logs(model_version);
CREATE INDEX idx_alert_timestamp ON monitoring_alerts(created_at);

COMMIT;
