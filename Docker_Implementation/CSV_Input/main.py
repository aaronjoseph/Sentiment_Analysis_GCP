from fastapi import FastAPI, File, UploadFile
import pandas as pd
from joblib import load

app = FastAPI()
vectorizer = load("count_vectorizer.joblib")
model = load("model.joblib")


@app.post("/predict_sentiment")
async def predict_sentiment(file: UploadFile):
    # NaiveBayes Implementation
    df = pd.read_csv(file.file)
    transform_data = vectorizer.transform(df["review"].values)
    prediction = model.predict(transform_data)
    sentiment_labels = ["Positive" if s == 1 else "Negative" for s in prediction]
    return {"sentiment": sentiment_labels}
