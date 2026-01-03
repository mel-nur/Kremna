FROM python:3.11-slim

WORKDIR /app

# (Opsiyonel ama iyi) Loglar anında gelsin
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Railway genelde 8080 bekler; yine de PORT env ile dinleyeceğiz
EXPOSE 8080

CMD ["sh", "-c", "cd main && uvicorn main_receiver:app --host 0.0.0.0 --port ${PORT:-8080}"]