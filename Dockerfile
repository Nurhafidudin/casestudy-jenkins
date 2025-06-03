FROM python:3.9

WORKDIR /app
COPY . .

RUN python -m pip install --upgrade pip && \
    pip install flask --default-timeout=100

CMD ["python", "app.py"]
