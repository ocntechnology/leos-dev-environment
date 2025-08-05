#!/bin/bash

# LEOS Production Deployment Script

set -e

echo "🚀 Deploying to LEOS Production Environment..."

# Check if we're on the production branch
if [ "$(git branch --show-current)" != "production" ]; then
    echo "❌ You must be on the production branch to deploy to production"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Confirm deployment
echo "⚠️  You are about to deploy to PRODUCTION!"
echo "   This will affect live users."
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled."
    exit 1
fi

# Set environment variables
export LEOS_ENVIRONMENT=production
export LEOS_VERSION=$(git rev-parse --short HEAD)
export DOCKER_REGISTRY=ghcr.io/your-org

# Build and push images
echo "🔨 Building and pushing Docker images..."

# Build LEOS Services
docker build -f docker/production/Dockerfile.leos-services -t $DOCKER_REGISTRY/leos-services:$LEOS_VERSION ./leos
docker push $DOCKER_REGISTRY/leos-services:$LEOS_VERSION

# Build LEOS UI
docker build -f docker/production/Dockerfile.leos-ui -t $DOCKER_REGISTRY/leos-ui:$LEOS_VERSION ./leos/modules/ui-angular
docker push $DOCKER_REGISTRY/leos-ui:$LEOS_VERSION

# Build Annotation Server
docker build -f docker/production/Dockerfile.annotate-server -t $DOCKER_REGISTRY/annotate-server:$LEOS_VERSION ./annotate
docker push $DOCKER_REGISTRY/annotate-server:$LEOS_VERSION

# Build Annotation Client
docker build -f docker/production/Dockerfile.annotate-client -t $DOCKER_REGISTRY/annotate-client:$LEOS_VERSION ./annotate/client-angular
docker push $DOCKER_REGISTRY/annotate-client:$LEOS_VERSION

# Deploy to production environment
echo "🚀 Deploying to production environment..."

# Load environment variables for production
if [ -f .env.production ]; then
    export $(cat .env.production | xargs)
fi

# Deploy using Docker Compose
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 60

# Health checks
echo "🔍 Running health checks..."

# Check LEOS Services
if curl -f https://leos.opencouncil.network/health > /dev/null 2>&1; then
    echo "✅ LEOS Services are healthy"
else
    echo "❌ LEOS Services health check failed"
    exit 1
fi

# Check Annotation Server
if curl -f https://leos.opencouncil.network/annotate/server/health > /dev/null 2>&1; then
    echo "✅ Annotation Server is healthy"
else
    echo "❌ Annotation Server health check failed"
    exit 1
fi

# Check LEOS UI
if curl -f https://leos.opencouncil.network/ > /dev/null 2>&1; then
    echo "✅ LEOS UI is healthy"
else
    echo "❌ LEOS UI health check failed"
    exit 1
fi

echo ""
echo "🎉 Production deployment completed successfully!"
echo ""
echo "📱 Access your production environment:"
echo "   • LEOS UI: https://leos.opencouncil.network/"
echo "   • Annotation Client: https://leos.opencouncil.network/annotate/client/"
echo "   • Monitoring: https://leos.opencouncil.network:3000/"
echo ""
echo "📊 View logs:"
echo "   docker-compose -f docker-compose.prod.yml logs -f"
echo ""
echo "🔔 Don't forget to:"
echo "   • Update DNS if needed"
echo "   • Check SSL certificates"
echo "   • Monitor application performance"
echo "   • Notify stakeholders of the deployment" 