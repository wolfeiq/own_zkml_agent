import google.colab
import subprocess
import sys
from torch import nn
import torch
import ezkl
from transformers import BertTokenizer, BertModel

wallet = #your wallet

def convert_wallet_ezkl(address):
    address_hex = f"{address:040x}"
    return torch.tensor([int(address_hex[i:i+2], 16) for i in range(0, len(address_hex), 2)], dtype=torch.uint8)

tip_recipient_tensor = convert_wallet_ezkl(wallet)

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.bert = BertModel.from_pretrained("bert-base-uncased")
        self.classifier = nn.Linear(self.bert.config.hidden_size, 1)

    def forward(self, input_ids, attention_mask):
        outputs = self.bert(input_ids=input_ids, attention_mask=attention_mask)
        pooled = outputs.pooler_output
        score = torch.sigmoid(self.classifier(pooled))
        return score

circuit = Model(tip_recipient_tensor)

dummy_input = torch.randint(0, 1000, (1, 64))
torch.onnx.export(circuit, (dummy_input, dummy_input), "comment_model.onnx")
