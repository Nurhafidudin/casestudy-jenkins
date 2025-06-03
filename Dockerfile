FROM python:3.9
WORKDIR /app
COPY . .
RUN pip install flask --default-timeout-100
CMD ["python", "app.py"]
