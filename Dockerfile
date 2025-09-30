FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache build-base libc6-compat \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del build-base

COPY . .

ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0

EXPOSE 8501

CMD ["streamlit", "run", "main.py", "--server.port", "8501", "--server.headless", "true"]
