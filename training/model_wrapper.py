"""
Phase 2: Continuous Training Infrastructure & MLflow Automation
Module: Model Wrapper & Transfer Learning Interface

Purpose:
    Unified interface for model loading, fine-tuning, and inference.
    Abstracts HuggingFace transformers complexity and enables easy swapping
    of different model architectures.
    
Learning Focus:
    Transfer learning best practices: freezing base layers, layer-specific
    learning rates, and checkpoint management. Demonstrates production-grade
    model abstraction patterns.
"""

from typing import Optional, Tuple, Dict, Any
from pathlib import Path
import torch
import torch.nn as nn
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from loguru import logger
import yaml


class ModelWrapper:
    """
    Unified interface for sentiment classification model.
    
    Supports:
    - Loading pre-trained models from HuggingFace
    - Fine-tuning with layer freezing
    - Inference on new samples
    - State management (save/load)
    """
    
    def __init__(self, model_name: str, config: Dict[str, Any]):
        """
        Initialize model wrapper.
        
        Args:
            model_name: HuggingFace model ID (e.g., 'distilbert-base-uncased')
            config: Model configuration dictionary from training_config.yaml
        """
        self.model_name = model_name
        self.config = config
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.tokenizer = None
        self.model = None
        
        logger.info(f"Using device: {self.device}")
        
    def load(self):
        """
        Load pre-trained model and tokenizer from HuggingFace.
        
        TODO: Implement
        - Load tokenizer with trust_remote_code=True
        - Load model with AutoModelForSequenceClassification
        - Move model to device
        - Log successful load
        """
        pass
    
    def freeze_layers(self, num_freeze: int):
        """
        Freeze first N transformer layers for transfer learning.
        
        Args:
            num_freeze: Number of layers to freeze from the bottom
            
        TODO: Implement
        - Access model.base_model (distilbert, etc)
        - Freeze first num_freeze transformer layers
        - Set requires_grad=False for frozen layers
        - Log which layers are frozen
        """
        pass
    
    def get_optimizer(self, learning_rate: float):
        """
        Create AdamW optimizer with layer-specific learning rates.
        
        Args:
            learning_rate: Base learning rate
            
        TODO: Implement
        - Use transformers.AdamW with weight_decay
        - Consider layer-specific LR (higher for final layers)
        - Return optimizer ready for backward pass
        """
        pass
    
    def forward(
        self,
        input_ids: torch.Tensor,
        attention_mask: torch.Tensor,
        token_type_ids: Optional[torch.Tensor] = None,
    ) -> torch.Tensor:
        """
        Forward pass through model.
        
        Args:
            input_ids: Token IDs from tokenizer
            attention_mask: Attention mask (1 for real tokens, 0 for padding)
            token_type_ids: Token type IDs (optional, not needed for distilBERT)
            
        TODO: Implement
        - Call self.model with appropriate kwargs
        - Return logits (unnormalized predictions)
        """
        pass
    
    def predict(self, text: str) -> Dict[str, Any]:
        """
        Make inference on a single text sample.
        
        Args:
            text: Input text string
            
        Returns:
            Dictionary with keys: prediction, confidence, logits
            
        TODO: Implement
        - Tokenize text
        - Forward pass
        - Apply softmax to get confidence
        - Return dict with label and confidence
        - Handle device movement
        """
        pass
    
    def save(self, output_dir: str):
        """
        Save model and tokenizer for later loading.
        
        Args:
            output_dir: Directory to save model files
            
        TODO: Implement
        - Create output directory if not exists
        - Save model.save_pretrained()
        - Save tokenizer.save_pretrained()
        - Log save location
        """
        pass
    
    @classmethod
    def load_checkpoint(cls, checkpoint_dir: str, config: Dict[str, Any]):
        """
        Load model from saved checkpoint.
        
        Args:
            checkpoint_dir: Directory with saved model
            config: Configuration dictionary
            
        Returns:
            Loaded ModelWrapper instance
            
        TODO: Implement
        - Create new instance
        - Load from checkpoint
        - Verify integrity
        - Return instance
        """
        pass


class TokenizationHelper:
    """Utility for consistent tokenization."""
    
    def __init__(self, tokenizer, max_length: int = 128):
        """
        Initialize tokenizer wrapper.
        
        Args:
            tokenizer: HuggingFace tokenizer instance
            max_length: Maximum sequence length
        """
        self.tokenizer = tokenizer
        self.max_length = max_length
    
    def tokenize_batch(self, texts: list) -> Dict[str, torch.Tensor]:
        """
        Tokenize batch of texts with padding and truncation.
        
        Args:
            texts: List of text strings
            
        TODO: Implement
        - Call tokenizer with batch_encode_plus
        - Apply padding and truncation
        - Return dict with input_ids, attention_mask, token_type_ids
        - Move to appropriate device
        """
        pass


if __name__ == "__main__":
    # Quick test
    config = yaml.safe_load(
        open("config/training_config.yaml")
    )
    wrapper = ModelWrapper(
        model_name=config["model"]["model_name"],
        config=config
    )
    print(f"✓ Wrapper initialized for {config['model']['model_name']}")
