#!/bin/bash

SERVICE_NAME="$1"
OUTPUT_DIR="${SERVICE_NAME}/diagrams"

if [ -z "$SERVICE_NAME" ]; then
  echo "Usage: $0 <SERVICE_NAME>"
  exit 1
fi

if [ ! -d "$SERVICE_NAME" ]; then
    echo "Error: Service '$SERVICE_NAME' does not exist."
    exit 1
fi

mkdir -p "${OUTPUT_DIR}"

for file in "${SERVICE_NAME}"/*.d2; do
  filename=$(basename -- "$file" .d2)
  d2 "$file" "$OUTPUT_DIR/$filename.svg"
done