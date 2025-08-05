#!/bin/bash

# LEOS Development Environment Stop Script

set -e

echo "🛑 Stopping LEOS Development Environment..."

# Stop all containers
docker-compose -f docker-compose.dev.yml down

echo "✅ Development environment stopped successfully!"

# Optional: Remove volumes (uncomment if you want to clear data)
# echo "🗑️ Removing volumes..."
# docker-compose -f docker-compose.dev.yml down -v

echo ""
echo "💡 To start the environment again, run:"
echo "   ./scripts/dev-start.sh" 