#!/bin/bash

# LEOS Development Environment Status Script
# This script shows the status of all repositories

echo "📊 LEOS Development Environment Status"
echo "======================================"
echo ""

# Main repository status
echo "🏠 Main Repository (leos-dev-environment):"
echo "   Branch: $(git branch --show-current)"
echo "   Status: $(git status --porcelain | wc -l) changes"
echo "   Latest: $(git log -1 --oneline)"
echo ""

# LEOS repository status
if [ -d "leos" ]; then
    echo "📝 LEOS Repository:"
    cd leos
    echo "   Branch: $(git branch --show-current)"
    echo "   Status: $(git status --porcelain | wc -l) changes"
    echo "   Latest: $(git log -1 --oneline)"
    echo "   Remote: $(git remote get-url origin)"
    cd ..
else
    echo "📝 LEOS Repository: Not cloned (run ./scripts/setup.sh)"
fi
echo ""

# Annotate repository status
if [ -d "annotate" ]; then
    echo "📋 Annotate Repository:"
    cd annotate
    echo "   Branch: $(git branch --show-current)"
    echo "   Status: $(git status --porcelain | wc -l) changes"
    echo "   Latest: $(git log -1 --oneline)"
    echo "   Remote: $(git remote get-url origin)"
    cd ..
else
    echo "📋 Annotate Repository: Not cloned (run ./scripts/setup.sh)"
fi
echo ""

# Docker status
echo "🐳 Docker Status:"
if command -v docker &> /dev/null; then
    if docker info > /dev/null 2>&1; then
        echo "   Docker: Running"
        echo "   Containers: $(docker ps -q | wc -l) running"
    else
        echo "   Docker: Not running"
    fi
else
    echo "   Docker: Not installed"
fi
echo ""

# Development environment status
echo "🔧 Development Environment:"
if [ -f "docker-compose.dev.yml" ]; then
    if [ -d "leos" ] && [ -d "annotate" ]; then
        echo "   Status: Ready to start"
        echo "   Run: ./scripts/dev-start.sh"
    else
        echo "   Status: Missing repositories"
        echo "   Run: ./scripts/setup.sh"
    fi
else
    echo "   Status: Configuration missing"
fi
echo ""

echo "📚 Quick Commands:"
echo "   • Setup: ./scripts/setup.sh"
echo "   • Start: ./scripts/dev-start.sh"
echo "   • Stop: ./scripts/dev-stop.sh"
echo "   • Update: ./scripts/update.sh"
echo "   • Status: ./scripts/status.sh" 