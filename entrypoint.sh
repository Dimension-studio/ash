#!/bin/bash

# Login to GHCR using the GitHub token and username provided as environment variables
if [ -n "$GHCR_TOKEN" ] && [ -n "$GHCR_USERNAME" ]; then
    echo "$GHCR_TOKEN" | docker login ghcr.io -u "$GHCR_USERNAME" --password-stdin
else
    echo "GHCR_TOKEN and GHCR_USERNAME environment variables are required."
    exit 1
fi

# Execute the main command
exec "$@"