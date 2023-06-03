FROM python:3.9.16-slim-buster

WORKDIR /app

LABEL maintainer="Sunn <sunn@atumm.org>"
LABEL version="1.0"
LABEL description="Docker image for building an appi flatpak app"

RUN pip install pdm

RUN apt-get update && \
    apt-get install -y make flatpak flatpak-builder \
    libgl1-mesa-glx \
    libegl1-mesa \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxrandr2 \
    libasound2 \
    libnss3 \
    libxss1 \
    libxkbfile1 \
    libdrm2 \
    libxshmfence1 && \
    rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pdm config python.use_venv false && \
    rm -f requirements.txt && \
    pdm export -f requirements > requirements.txt && \
    pip install -r requirements.txt

RUN echo "run:\n make compile && make flatpak-build\n"

CMD ["/bin/bash"]
