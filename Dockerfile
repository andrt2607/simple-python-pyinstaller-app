FROM python:3.9-slim-bullseye

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY sources/ sources/

EXPOSE 5000

CMD ["python3", "sources/app.py"]
