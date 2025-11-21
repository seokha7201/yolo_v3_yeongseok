#!/bin/bash

IMAGE_NAME="seokha7201/yolo"
CONTAINER_NAME="yolo_gen"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <image_url>"
    exit 1
fi

IMAGE_URL="$1"

docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1

docker run --name "$CONTAINER_NAME" "$IMAGE_NAME" "$IMAGE_URL"

docker cp "$CONTAINER_NAME":/darknet/predictions.jpg ./result.jpg

docker rm -f "$CONTAINER_NAME" > /dev/null 2>&1

echo "Done. Saved to result.jpg"
