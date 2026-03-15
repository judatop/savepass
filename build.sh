#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "No environment specified. Usage: ./build.sh <dev|prod>"
  exit 1
fi

echo "Setting environment to $ENV"

cp ".env.$ENV" ".env" || exit 1

echo "Cleaning build_runner..."
dart run build_runner clean

echo "Generating env.g.dart..."
dart run build_runner build --delete-conflicting-outputs || exit 1

echo "Environment $ENV ready"