#!/bin/bash

# LEOS Development Environment Update Script
# This script updates all repositories to their latest versions

set -e

echo "🔄 Updating LEOS Development Environment repositories..."

# Update LEOS repository
if [ -d "leos" ]; then
    echo "📥 Updating LEOS repository..."
    cd leos
    
    # Fetch latest changes
    git fetch origin
    git fetch github 2>/dev/null || true
    
    # Show current status
    echo "Current LEOS branch: $(git branch --show-current)"
    echo "Latest commit: $(git log -1 --oneline)"
    
    # Pull latest changes
    git pull origin main
    
    cd ..
    echo "✅ LEOS repository updated"
else
    echo "⚠️  LEOS repository not found. Run ./scripts/setup.sh first"
fi

# Update annotate repository
if [ -d "annotate" ]; then
    echo "📥 Updating annotate repository..."
    cd annotate
    
    # Fetch latest changes
    git fetch origin
    git fetch upstream 2>/dev/null || true
    
    # Show current status
    echo "Current annotate branch: $(git branch --show-current)"
    echo "Latest commit: $(git log -1 --oneline)"
    
    # Pull latest changes
    git pull origin main
    
    cd ..
    echo "✅ Annotate repository updated"
else
    echo "⚠️  Annotate repository not found. Run ./scripts/setup.sh first"
fi

# Update main repository
echo "📥 Updating main repository..."
git fetch origin
git pull origin main

echo ""
echo "🎉 All repositories updated!"
echo ""
echo "📊 Repository status:"
echo "   • Main repo: $(git log -1 --oneline)"
if [ -d "leos" ]; then
    echo "   • LEOS: $(cd leos && git log -1 --oneline)"
fi
if [ -d "annotate" ]; then
    echo "   • Annotate: $(cd annotate && git log -1 --oneline)"
fi
echo ""
echo "🚀 To restart with latest changes:"
echo "   ./scripts/dev-stop.sh && ./scripts/dev-start.sh" 