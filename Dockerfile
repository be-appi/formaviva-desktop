FROM python:3.9.16-slim-buster

WORKDIR /app

LABEL maintainer="Sunn <sunn@atumm.org>"
LABEL version="1.0"
LABEL description="Docker image for building an appi flatpak app"

RUN pip install pdm

RUN apt-get update && \
    apt-get install -y flatpak flatpak-builder && \
    rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pdm config python.use_venv false && \
    rm -f requirements.txt && \
    pdm export -f requirements > requirements.txt && \
    pip install -r requirements.txt

RUN echo "run:\n make compile && make flatpak-build\n"

CMD ["/bin/bash"]
