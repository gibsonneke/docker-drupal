#!/bin/bash

if [[ ! -e "assets" ]]; 
then
  echo "Create the assets folder"
  mkdir assets
fi

if [[ ! -e "db" ]]; 
then
  echo "Create the db folder"
  mkdir db
fi

if [[ ! -f "assets/smtp.json" ]];
then
  echo "Copy example smtp.json to project root"
  cp docker/mailhog/example.smtp.json assets/smtp.json
fi

wait

docker-compose -f docker-compose.yml up -d

wait

if [[ ! -e "vendor" ]]; 
then
  echo "Running composer install since this has not been done yet"
  docker-compose run --rm phpfpm composer install
fi

if [ "$(stat -c '%a' web/sites/default/files)" != "777" ]
then
  chmod -R 777 web/sites/default/files
fi

if [ "$(stat -c '%a' web/sites/default/private)" != "777" ]
then
  chmod -R 777 web/sites/default/private
fi

docker-compose -f docker-compose.yml ps
