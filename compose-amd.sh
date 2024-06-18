#!/bin/sh

# Load environment variables from .env file
set -a
. .env
set +a


services=""
if [ "$ENABLE_LLAMA" = "true" ]; then
  services="$services llama"
fi
if [ "$ENABLE_SD" = "true" ]; then
  services="$services sd"
fi

#remove the first space
services="${services# }"

# Function to build the images
build_images() {
  echo "Building the images for services: $services"
  docker-compose -f docker-compose.amd.yml build nginx $services
}

# Function to start the containers
start_containers() {
  
  #need to define profiles like --profile llama --profile sd to use services for that, make some fancy string manipulation
  local profiles=""
  for service in $services; do
    profiles="$profiles --profile $service"
  done

  echo "Starting the containers for services: $profiles"
  docker-compose -f docker-compose.amd.yml $profiles up -d --remove-orphans 
}

# Function to stop the containers
stop_containers() {
  echo "Stopping the containers..."
  docker-compose -f docker-compose.amd.yml stop
}

# Function to restart the containers
restart_containers() {
  echo "Restarting the containers..."
  docker-compose -f docker-compose.amd.yml restart
}

# Function to remove the containers
remove_containers() {
  echo "Removing the containers..."
  docker-compose -f docker-compose.amd.yml down
}

# Function to display container status
container_status() {
  echo "Container status:"
  docker-compose -f docker-compose.amd.yml ps
}

# Parse command line arguments
case "$1" in
  start)
    start_containers
    ;;
  stop)
    stop_containers
    ;;
  restart)
    stop_containers
    start_containers
    ;;
  remove)
    stop_containers
    remove_containers
    ;;
  status)
    container_status
    ;;
  rebuild)
    build_images
    ;;
  build)
    build_images
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|remove|status|rebuild|build}"
    exit 1
    ;;
esac