#!/bin/bash

# ljsricky ID 적용 완료
IMAGE_NAME="seokha7201/yolo"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <image_url>"
    echo "예시: $0 https://upload.wikimedia.org/..."
    exit 1
fi

IMAGE_URL="$1"

docker run --rm "$IMAGE_NAME" "$IMAGE_URL"
