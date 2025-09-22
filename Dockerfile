FROM python:3.13-bullseye
WORKDIR /code
# Install rsync and openssh-client
RUN apt-get update && apt-get install -y --no-install-recommends rsync openssh-client && \
    rm -rf /var/lib/apt/lists/*
COPY . /code
CMD ["python3", "-m", "rsync.sync_files"]

