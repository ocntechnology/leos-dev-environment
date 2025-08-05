#!/bin/bash

# LEOS Development Environment Logs Script

# Default to all services
SERVICE=${1:-""}

echo "📊 Viewing LEOS Development Environment logs..."

if [ -z "$SERVICE" ]; then
    echo "📋 Showing logs for all services..."
    docker-compose -f docker-compose.dev.yml logs -f
else
    echo "📋 Showing logs for service: $SERVICE"
    docker-compose -f docker-compose.dev.yml logs -f "$SERVICE"
fi 