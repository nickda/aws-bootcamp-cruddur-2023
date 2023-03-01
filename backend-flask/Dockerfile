# Stage 1: Build the application
FROM python:3.10-slim-buster AS builder

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install --user --no-cache-dir -r requirements.txt

COPY . .

# Stage 2: Run the application
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY run_flask.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_flask.sh

ENV FLASK_ENV=development

EXPOSE ${PORT}

CMD [ "/usr/local/bin/run_flask.sh"]