import uvicorn
from fastapi import FastAPI
from joblib import load

app = FastAPI()
vectorizer = load("count_vectorizer.joblib")
model = load("model.joblib")


@app.post("/predict_sentiment")
async def predict_sentiment(text: str):
    # NaiveBayes Implementation
    transform_data = vectorizer.transform([text])
    prediction = model.predict(transform_data)
    if prediction[0] == 1:
        return {"sentiment": "Positive"}
    else:
        return {"sentiment": "Negative"}
