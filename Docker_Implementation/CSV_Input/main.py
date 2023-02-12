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
    try:
        transform_data = vectorizer.transform(df["review"].values)
        prediction = model.predict(transform_data)
        setiment_dict = {"review": df["review"].tolist(),"sentiments":["Positive" if s == 1 else "Negative" for s in prediction]}
        return setiment_dict
    except:
        return{"message":"Please validate if the dataframe has review column"}