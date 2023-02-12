import pandas as pd
import torch
from transformers import DistilBertTokenizer, DistilBertForSequenceClassification

tokenizer = DistilBertTokenizer.from_pretrained("distilbert-base-uncased")
model = DistilBertForSequenceClassification.from_pretrained("distilbert-base-uncased")
model = model.half()

df = pd.read_csv("../Data/reviews_training_26000.csv")
df = df[["review", "sentiment"]]
df["sentiment"] = (df["sentiment"] == "positive").astype(int)

input_ids = []
attention_masks = []

for review in df["review"].values:
    encoded_dict = tokenizer.encode_plus(
        review,
        add_special_tokens=True,
        max_length=512,
        pad_to_max_length=True,
        return_attention_mask=True,
        return_tensors="pt",
    )

    input_ids.append(encoded_dict["input_ids"])
    attention_masks.append(encoded_dict["attention_mask"])
input_ids = torch.cat(input_ids, dim=0)
attention_masks = torch.cat(attention_masks, dim=0)
labels = torch.tensor(
    df["sentiment"].values, dtype=torch.float32
)  # Facing LayerNormKernelmpl error, distilbert needs float32
batch_size = 32  # Having issues on my Laptop, testing with 32 as batch size
train_data = torch.utils.data.TensorDataset(input_ids, attention_masks, labels)
train_sampler = torch.utils.data.RandomSampler(train_data)
train_dataloader = torch.utils.data.DataLoader(
    train_data, sampler=train_sampler, batch_size=batch_size
)

model.train()  # To Update the weights of the model for our use-case
criterion = torch.nn.BCELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=2e-5)

# Track the loss and accuracy during training
total_loss = 0
num_correct = 0
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Train the model for a set number of epochs
for epoch in range(4):
    for step, batch in enumerate(train_dataloader):
        # Unpack the inputs from our dataloader

        b_input_ids = batch[0].to(device)
        b_input_mask = batch[1].to(device)
        b_labels = batch[2].to(device)

        # Zero the gradients from previous iteration
        optimizer.zero_grad()

        # Forward pass
        outputs = model(b_input_ids, attention_mask=b_input_mask, labels=b_labels)

        # Get the loss value for this batch
        loss = outputs[0]
