FROM python:3.11-bullseye
WORKDIR /code/rsync
# Install rsync
RUN apt-get update && apt-get install -y rsync && rm -rf /var/lib/apt/lists/*
# Set up SSH known_hosts dynamically for multiple servers
ARG SERVER_NAMES
RUN mkdir -p /root/.ssh && \
    echo "Adding servers to known_hosts: $SERVER_NAMES" && \
    for server in $(echo $SERVER_NAMES | tr ',' ' '); do \
        ssh-keyscan -H $server >> /root/.ssh/known_hosts; \
    done
CMD ["python3", "/code/rsync/sync_files.py"]

# Docker commands to create image and run container:
# docker build --build-arg SERVER_NAMES=server1,server2,server3 -t rsync .
# docker run -it --rm -v /home/syncuser/.ssh/id_rsa:/root/.ssh/id_rsa:ro -v /data/dev/workspace/rsync:/code/rsync --name rsync rsync python3 -m rsync.sync_files example_config_file.json
