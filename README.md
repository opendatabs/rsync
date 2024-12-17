# **rsync Automation Tool**

This repository contains a Python-based utility for automating file and directory synchronization using `rsync` over SSH. It leverages a JSON configuration file to define sync parameters and runs inside a lightweight Docker container for portability and consistency.

---

## **Overview**

The project includes:
1. **`Dockerfile`**: Builds a Docker container with `rsync` and necessary dependencies.
2. **Python Script**: Automates `rsync` execution using configurations provided in JSON files.
3. **Config Files**: JSON files that define source directories, remote destinations, and SSH authentication settings.

---

## **Features**
- **Automated File Synchronization**: Uses `rsync` to transfer files securely over SSH.
- **Configuration-Driven**: Easy-to-edit JSON files define the behavior of the sync operation.
- **Containerized Environment**: Can be run using Docker.
- **Secure SSH Integration**: Supports private key-based authentication.

---

## **Folder Behavior with Trailing `/`**

The presence or absence of a trailing `/` in the source or destination path changes the behavior of `rsync`:

| Source        | Destination       | Behavior                                |
|---------------|-------------------|-----------------------------------------|
| `/source`     | `/destination`    | Copies `source` directory **and its contents** into `destination` as a subdirectory (`/destination/source/`). |
| `/source/`    | `/destination`    | Copies **contents** of `source` directly into `destination` without creating a `source` subdirectory. |
| `/source`     | `/destination/`   | Same as above: creates `/destination/source/`. |
| `/source/`    | `/destination/`   | Copies **contents** of `source` into `destination`. |

---

## **Repository Structure**

```plaintext
.
├── Dockerfile              # Docker image that sets up rsync and dependencies
├── sync_files.py                # Main script that orchestrates rsync
├── config_files/           # Configuration files for rsync
│   ├── example_config.json # Example JSON configuration file
└── README.md               # Documentation
```

---

## **Configuration File**

The configuration file is a JSON object containing the following required fields:

```json
{
  "source": "/path/to/source/",           // Source directory
  "destination": "/path/to/destination/", // Remote directory
  "remote_host": "example.com",           // Remote server hostname or IP
  "ssh_key_path": "/path/to/id_rsa",      // Path to SSH private key
  "remote_user": "username"               // Remote server username
}
```

---

## **How It Works**

1. **Build the Docker Image**:
   Use the provided `Dockerfile` to build the image:
   ```bash
   docker build --build-arg SERVER_NAMES=server1,server2,server3 -t rsync .
   ```
   The remote server hostname or IP need to be specified

2. **Run the Docker Container**:
   Mount the necessary directories and provide a configuration file:
   ```bash
   docker run -it --rm \
       -v /path/to/id_rsa:/root/.ssh/id_rsa:ro \
       -v /path/to/data:/code/rsync \
       rsync-automation python3 /code/rsync/sync_files.py example_config.json
   ```

   - `/path/to/id_rsa`: SSH private key mounted as read-only (`:ro`).
   - `/path/to/data`: Local data directory to sync.

3. **Behavior**:
   The Python script reads the configuration file, constructs the `rsync` command, and executes it securely over SSH.

---

## **Example Usage**

Given the following `example_config.json`:
```json
{
  "source": "/code/data-processing/source/",
  "destination": "/remote/data/destination/",
  "remote_host": "example.com",
  "ssh_key_path": "/home/syncuser/.ssh/id_rsa",
  "remote_user": "syncuser"
}
```

### Run the Script:
```bash
docker run -it --rm \
    -v /home/syncuser/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
    -v /data/dev/workspace/rsync:/code/rsync \
    rsync-automation python3 /code/rsync/rsync.py example_config.json
```

### Result:
- The **contents** of `/code/data-processing/source/` are synced to `/remote/data/destination/` on the remote server.
- SSH authentication uses the provided `id_rsa` key.

---

## **Troubleshooting**

- **Permission Denied**: Ensure correct permissions for SSH keys and write access for destination directories.
- **Trailing `/` Behavior**: Check the source and destination paths for trailing `/` to get the desired behavior (see table above).
- **SSH Key Issues**: Verify the key file path and host permissions in `~/.ssh/known_hosts`.

---

## **License**

This project is licensed under the MIT License.

---

## **Contributing**

Contributions are welcome! Please open issues or submit pull requests to suggest improvements or report bugs.

---
