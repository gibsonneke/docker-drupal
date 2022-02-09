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

if [[ ! -e "web/sites/default/files" ]]; 
then
  echo "Create the files folder"
  mkdir web/sites/default/files
  chmod -R 777 web/sites/default/files
fi

if [[ ! -e "web/sites/default/private" ]]; 
then
  echo "Create the private folder"
  mkdir web/sites/default/private
  mkdir web/sites/default/private/temp
  chmod -R 777 web/sites/default/private
fi

if [[ ! -f "assets/smtp.json" ]];
then
  echo "Copy example smtp.json to the asset folder"
  cp docker/mailhog/example.smtp.json assets/smtp.json
fi

if [[ ! -f "web/sites/default/settings.php" ]];
then
  echo "Prepare the settings.php file for installation"
  cp web/sites/default/default.settings.php web/sites/default/settings.php
fi

if [[ ! -f "web/sites/default/settings.local.php" ]];
then
  echo "Prepare the settings.local.php file for installation"
  cp web/sites/example.settings.local.php web/sites/default/settings.local.php
fi

if [[ ! -f "web/sites/default/services.yml" ]];
then
  echo "Prepare the services.yml file for installation"
  cp web/sites/default/default.services.yml web/sites/default/services.yml
fi

wait

docker-compose -f docker-compose.yml up -d

wait

if [[ ! -e "vendor" ]]; 
then
  echo "Running composer install since this has not been done yet"
  docker-compose run --rm phpfpm composer install
fi

docker-compose -f docker-compose.yml ps
