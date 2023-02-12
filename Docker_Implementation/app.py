from fastapi import FastAPI

app = FastAPI()

@app.post("/predict_sentiment")
async def predict_sentiment(text: str):
    if len(text.split()) > 10:
        return {"sentiment": "Positive"}
    else:
        return {"sentiment": "Negative"}
