# Variables
IMAGE_NAME := pocketbase
VERSION := 0.25.0
DOCKER_REGISTRY := ghcr.io/paulicstudios

.PHONY: build push clean

default: build

# Create and use buildx builder for multi-arch support
setup-buildx:
	docker buildx create --name multiarch-builder --use || true

# Build multi-architecture images
build: setup-buildx
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg PB_VERSION=$(VERSION) \
		-t $(IMAGE_NAME):$(VERSION) \
		-t $(IMAGE_NAME):latest \
		--load \
		.

# Push multi-architecture images to registry
push:
ifdef DOCKER_REGISTRY
	docker tag $(IMAGE_NAME):$(VERSION) $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)
	docker tag $(IMAGE_NAME):$(VERSION) $(DOCKER_REGISTRY)/$(IMAGE_NAME):latest
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(VERSION)
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):latest
else
	@echo "DOCKER_REGISTRY is not set"
endif

# Clean up local images
clean:
	docker rmi $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest || true
	docker buildx rm multiarch-builder || true
