#!/bin/bash

# LEOS Test Runner Script

set -e

echo "🧪 Running LEOS tests..."

# Run backend tests
echo "🔧 Running backend tests..."
docker-compose -f docker-compose.dev.yml exec leos-services ./mvnw test

# Run frontend tests
echo "🎨 Running frontend tests..."
docker-compose -f docker-compose.dev.yml exec leos-ui npm test

# Run annotation tests
echo "📝 Running annotation tests..."
docker-compose -f docker-compose.dev.yml exec annotate-server ./mvnw test
docker-compose -f docker-compose.dev.yml exec annotate-client npm test

echo "✅ All tests completed!" 