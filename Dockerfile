FROM --platform=$BUILDPLATFORM alpine:3

# Build arguments
ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG PB_VERSION=0.25.0

# Install dependencies
RUN apk add --no-cache \
    ca-certificates \
    unzip \
    wget && \
    rm -rf /var/cache/apk/*

# Create a non-root user
RUN adduser -D pocketbase
USER pocketbase

# Create data directory
RUN mkdir /home/pocketbase/pb_data
WORKDIR /home/pocketbase

# Set the correct architecture for download
RUN case "${TARGETPLATFORM}" in \
    "linux/amd64") ARCH="amd64" ;; \
    "linux/arm64") ARCH="arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${ARCH}.zip \
    && unzip pocketbase_${PB_VERSION}_linux_${ARCH}.zip \
    && rm pocketbase_${PB_VERSION}_linux_${ARCH}.zip \
    && chmod +x ./pocketbase

# Expose the default PocketBase port
EXPOSE 8090

# Start PocketBase
ENTRYPOINT [ "./pocketbase", "serve", "--http=0.0.0.0:8090" ]