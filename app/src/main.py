from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn

app = FastAPI()

class EchoRequest(BaseModel):
    message: str

@app.get("/health")
def health():
    return {
        "ok": True,
        "runtime": "python",
        "message": "Python API is running"
    }

@app.post("/echo")
def echo(body: EchoRequest):
    return {
        "ok": True,
        "source": "python",
        "echo": body.message
    }

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)