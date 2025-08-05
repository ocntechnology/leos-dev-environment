#!/bin/bash

# LEOS Development Environment Setup Script
# This script sets up the multiple repository approach

set -e

echo "🚀 Setting up LEOS Development Environment..."

# Check if we're in the right directory
if [ ! -f "docker-compose.dev.yml" ]; then
    echo "❌ Please run this script from the leos-dev-environment directory"
    exit 1
fi

# Clone LEOS repository
if [ ! -d "leos" ]; then
    echo "📥 Cloning LEOS repository..."
    git clone https://github.com/TobyAbel/ocn-leos.git leos
else
    echo "✅ LEOS repository already exists"
fi

# Clone annotate repository
if [ ! -d "annotate" ]; then
    echo "📥 Cloning annotate repository..."
    git clone https://github.com/TobyAbel/ocn-annotate.git annotate
else
    echo "✅ Annotate repository already exists"
fi

# Make scripts executable
chmod +x scripts/*.sh

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📁 Repository structure:"
echo "   • leos-dev-environment/ (this repo) - Docker/CI/CD setup"
echo "   • leos/ - LEOS core application"
echo "   • annotate/ - Annotation module"
echo ""
echo "🚀 Next steps:"
echo "   1. Start development environment: ./scripts/dev-start.sh"
echo "   2. View documentation: ./docs/development.md"
echo "   3. Check troubleshooting: ./docs/troubleshooting.md"
echo ""
echo "📚 Useful commands:"
echo "   • Start dev environment: ./scripts/dev-start.sh"
echo "   • Stop dev environment: ./scripts/dev-stop.sh"
echo "   • View logs: ./scripts/dev-logs.sh"
echo "   • Run tests: ./scripts/test.sh"
echo "   • Update repositories: ./scripts/update.sh" 