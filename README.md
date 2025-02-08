# PocketBase Docker Image Builder

This repository contains the Dockerfile and Makefile used to build and publish multi-architecture Docker images for [PocketBase](https://pocketbase.io/).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) with Buildx support
- [Make](https://www.gnu.org/software/make/)
- (Optional) Access credentials for your target Docker registry

## Usage

### Building the Image

To build the Docker image for both AMD64 and ARM64, run:

```sh
make build
```

This command will:
- Set up a multi-architecture Buildx builder.
- Build the Docker image using a multi-stage build (builder and final stages).
- Tag the image with both the version specified and `latest`.

### Pushing the Image to a Registry

To push the built images to your Docker registry, run:

```sh
make push
```

The Makefile is set up to tag the images and push them to the registry specified by the `DOCKER_REGISTRY` variable.

### Cleaning Up

To remove the locally built images and the Buildx builder, run:

```sh
make clean
```

## Configuration

### Changing the PocketBase Version

The PocketBase version to be installed is set via the `VERSION` variable in the Makefile. To change the version, edit the Makefile:

```makefile
VERSION := 0.25.0  # Change this to your desired PocketBase version
```

### Changing the Docker Registry

If you need to push the image to a different registry, update the `DOCKER_REGISTRY` variable in the Makefile:

```makefile
DOCKER_REGISTRY := registry.coregame.de  # Replace with your target Docker registry
```

## Makefile Targets Summary

- `make build`: Builds multi-architecture Docker images.
- `make push`: Tags and pushes the images to the configured Docker registry.
- `make clean`: Cleans up local images and removes the Buildx builder.
- `make setup-buildx`: Sets up the multi-architecture Buildx builder (automatically run before builds).

## Image Details

- **Builder Stage:** Uses `alpine:3` to download, unzip, and prepare the PocketBase binary.
- **Final Stage:** Uses `alpine:3` (or a minimal image) to run the PocketBase binary as a non-root user.
- **Ports Exposed:** 8090
- **User:** The final image uses a non-root `pocketbase` user.
- **Entry Point:** The container starts PocketBase with the command:
  ```sh
  ./pocketbase serve --http=0.0.0.0:8090
  ```

---
