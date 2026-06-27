"""
Phase 1: Data Infrastructure & Ingestion Quality
Module: Sample Data Generator

Purpose:
    Generate synthetic sentiment classification data for local training and testing.
    Mimics real data ingestion patterns with timestamp, text content, and labels.
    
Learning Focus:
    Demonstrates how to generate reproducible test data for MLOps workflows,
    important for local development without dependency on live data sources.
"""

import json
import random
from datetime import datetime, timedelta
from typing import List, Dict, Any
from loguru import logger
import argparse


# Sample positive reviews (sentiment=1)
POSITIVE_REVIEWS = [
    "This product is absolutely amazing! I love it.",
    "Excellent quality and fast delivery. Highly recommended.",
    "Best purchase I've made. Worth every penny.",
    "Outstanding customer service. Very satisfied.",
    "The product exceeded my expectations. Great value.",
    "Perfect! Just what I needed.",
    "Fantastic! Everyone should have one.",
]

# Sample negative reviews (sentiment=0)
NEGATIVE_REVIEWS = [
    "Terrible product. Stopped working after a week.",
    "Worst purchase ever. Complete waste of money.",
    "Poor quality. Exactly as bad as the reviews said.",
    "Broke on first use. Very disappointed.",
    "Totally useless. Dont bother buying.",
    "Horrible experience. Customer service was unhelpful.",
    "Would give zero stars if possible.",
]


class SampleDataGenerator:
    """Generate synthetic sentiment classification data."""
    
    def __init__(self, seed: int = 42):
        """
        Initialize generator with fixed seed for reproducibility.
        
        Args:
            seed: Random seed for reproducible data generation
        """
        random.seed(seed)
        self.seed = seed
        
    def generate_samples(
        self,
        n_samples: int = 1000,
        positive_ratio: float = 0.5,
        start_date: datetime = None
    ) -> List[Dict[str, Any]]:
        """
        Generate synthetic sentiment data.
        
        Args:
            n_samples: Total number of samples to generate
            positive_ratio: Fraction of positive samples (0-1)
            start_date: Start date for timestamps; defaults to now
            
        Returns:
            List of dictionaries with keys: text, label, timestamp, source
        """
        if start_date is None:
            start_date = datetime.now() - timedelta(days=30)
            
        n_positive = int(n_samples * positive_ratio)
        n_negative = n_samples - n_positive
        
        samples = []
        
        # Generate positive samples
        for i in range(n_positive):
            timestamp = start_date + timedelta(
                seconds=random.randint(0, 30 * 24 * 3600)
            )
            sample = {
                "text": random.choice(POSITIVE_REVIEWS),
                "label": "positive",
                "timestamp": timestamp.isoformat(),
                "source": random.choice(["website", "mobile", "api"]),
            }
            samples.append(sample)
        
        # Generate negative samples
        for i in range(n_negative):
            timestamp = start_date + timedelta(
                seconds=random.randint(0, 30 * 24 * 3600)
            )
            sample = {
                "text": random.choice(NEGATIVE_REVIEWS),
                "label": "negative",
                "timestamp": timestamp.isoformat(),
                "source": random.choice(["website", "mobile", "api"]),
            }
            samples.append(sample)
        
        # Shuffle and return
        random.shuffle(samples)
        return samples
    
    def save_to_jsonl(self, samples: List[Dict[str, Any]], filepath: str):
        """
        Save samples to JSONL file (one JSON object per line).
        
        Args:
            samples: List of sample dictionaries
            filepath: Output file path
        """
        try:
            with open(filepath, 'w') as f:
                for sample in samples:
                    f.write(json.dumps(sample) + '\n')
            logger.info(f"Generated {len(samples)} samples to {filepath}")
        except Exception as e:
            logger.error(f"Error saving samples: {e}")
            raise


def main():
    """CLI interface for data generation."""
    parser = argparse.ArgumentParser(
        description="Generate synthetic sentiment data"
    )
    parser.add_argument(
        "--n_samples", type=int, default=1000,
        help="Number of samples to generate"
    )
    parser.add_argument(
        "--output", type=str, default="data/raw/sample_data.jsonl",
        help="Output file path"
    )
    parser.add_argument(
        "--positive_ratio", type=float, default=0.5,
        help="Ratio of positive samples (0-1)"
    )
    parser.add_argument(
        "--seed", type=int, default=42,
        help="Random seed for reproducibility"
    )
    
    args = parser.parse_args()
    
    generator = SampleDataGenerator(seed=args.seed)
    samples = generator.generate_samples(
        n_samples=args.n_samples,
        positive_ratio=args.positive_ratio
    )
    generator.save_to_jsonl(samples, args.output)
    
    logger.info(f"✓ Generated {len(samples)} samples")
    logger.info(f"  Positive: {sum(1 for s in samples if s['label'] == 'positive')}")
    logger.info(f"  Negative: {sum(1 for s in samples if s['label'] == 'negative')}")


if __name__ == "__main__":
    main()
