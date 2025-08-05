#!/bin/bash

# LEOS Development Environment Startup Script
# This script starts all services for local development with hot reloading

set -e

echo "🚀 Starting LEOS Development Environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

# Create necessary directories
mkdir -p logs
mkdir -p data

# Set environment variables
export LEOS_ENVIRONMENT=development
export COMPOSE_PROJECT_NAME=leos-dev

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.dev.yml down

# Build and start services
echo "🔨 Building and starting services..."
docker-compose -f docker-compose.dev.yml up -d --build

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🔍 Checking service health..."

# Check LEOS Services
if curl -f http://localhost:8080/leos-pilot/ui/ > /dev/null 2>&1; then
    echo "✅ LEOS Services are running"
else
    echo "❌ LEOS Services are not responding"
fi

# Check Annotation Server
if curl -f http://localhost:9099/health > /dev/null 2>&1; then
    echo "✅ Annotation Server is running"
else
    echo "❌ Annotation Server is not responding"
fi

# Check CMIS Repository
if curl -f http://localhost:9090/chemistry-opencmis-server-inmemory/ > /dev/null 2>&1; then
    echo "✅ CMIS Repository is running"
else
    echo "❌ CMIS Repository is not responding"
fi

# Check Nginx
if curl -f http://localhost/health > /dev/null 2>&1; then
    echo "✅ Nginx is running"
else
    echo "❌ Nginx is not responding"
fi

echo ""
echo "🎉 LEOS Development Environment is ready!"
echo ""
echo "📱 Access your applications:"
echo "   • LEOS UI: http://localhost/leos-pilot/ui/"
echo "   • Annotation Client: http://localhost/annotate/client/"
echo "   • CMIS Repository: http://localhost:9090/"
echo "   • H2 Database Console: http://localhost:9094/"
echo ""
echo "🔧 Development URLs (direct access):"
echo "   • LEOS UI (Angular): http://localhost:4200/"
echo "   • LEOS Services: http://localhost:8080/"
echo "   • Annotation Client: http://localhost:4201/"
echo "   • Annotation Server: http://localhost:9099/"
echo ""
echo "📊 View logs:"
echo "   • All services: docker-compose -f docker-compose.dev.yml logs -f"
echo "   • LEOS Services: docker-compose -f docker-compose.dev.yml logs -f leos-services"
echo "   • LEOS UI: docker-compose -f docker-compose.dev.yml logs -f leos-ui"
echo ""
echo "🛑 To stop the environment:"
echo "   docker-compose -f docker-compose.dev.yml down" 