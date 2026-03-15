#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "No environment specified. Exiting."
  exit 1
fi

cp ".env.$ENV" ".env"

# Add any other setup tasks here
echo "Environment set to $ENV"
     
# chmod +x pre_build.sh - make the script executable