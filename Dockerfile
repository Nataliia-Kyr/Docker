FROM python:2.7
RUN mkdir -p /app
WORKDIR /app
COPY . /app
ENTRYPOINT python app.py
