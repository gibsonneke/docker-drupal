#!/bin/bash

if [[ ! -f "assets/smtp.json" ]];
then
  echo "Copy example smtp.json to project root"
  cp docker/mailhog/example.smtp.json assets/smtp.json
fi

wait

docker-compose -f docker-compose.yml up -d
docker-compose -f docker-compose.yml ps
