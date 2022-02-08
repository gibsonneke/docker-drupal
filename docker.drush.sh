#!/bin/bash

if [[ ! -f "vendor/drush/drush/drush" ]];
then
  echo "Install drush within the project"
  docker-compose run --rm phpfpm composer require drush/drush
fi

wait

docker-compose run --rm phpfpm /usr/local/apache2/htdocs/vendor/drush/drush/drush "$@"
