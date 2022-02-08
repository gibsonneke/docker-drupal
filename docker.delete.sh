#!/bin/bash

echo "Clean up docker environment"

docker-compose -f docker-compose.yml down
docker volume prune -f
