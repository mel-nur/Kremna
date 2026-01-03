
"""
Basit Local API Sunucusu (FastAPI)

Belirlenmiş bir port üzerinden ana (main) dosyaya JSON formatında veri iletir.
"""
# YAZAN: DevOps & Backend Developer


# YAZAN: Backend Developer
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import uvicorn
import requests
import os


# YAZAN: DevOps
# Ayarlanabilir port (varsayılan: 8000)
PORT = int(os.getenv("LOCAL_API_PORT", 8080))
# Main sunucunun base URL'i
MAIN_BASE_URL = os.getenv("MAIN_BASE_URL", "http://localhost:8080")


# YAZAN: Backend Developer
app = FastAPI()


# YAZAN: Backend Developer
@app.post("/send_json")
async def send_json_to_main(request: Request):
    """
    İstemciden JSON alır, endpoint bilgisine göre main dosyasına iletir.
    """
    try:
        data = await request.json()
        # JSON'dan endpoint bilgisini al (varsayılan: /receive_json)
        target_endpoint = data.get("endpoint", "/receive_json")
        # Tam URL oluştur
        full_url = f"{MAIN_BASE_URL}{target_endpoint}"
        # Main dosyasına POST ile ilet
        response = requests.post(full_url, json=data, timeout=10)
        return JSONResponse(content={
            "status": "success",
            "main_status_code": response.status_code,
            "main_response": response.json() if response.headers.get("content-type", "").startswith("application/json") else response.text
        })
    except Exception as e:
        return JSONResponse(content={"status": "error", "detail": str(e)}, status_code=500)


# YAZAN: DevOps
if __name__ == "__main__":
    uvicorn.run("local_api_server:app", host="0.0.0.0", port=PORT, reload=True)