FROM python:3.11-slim

WORKDIR /app
COPY . .

RUN pip install -r requirements.txt

EXPOSE ${APP_PORT}

CMD ["python", "app.py"]
