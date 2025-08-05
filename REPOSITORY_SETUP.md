# LEOS Repository Setup Guide

## 🎯 **Recommended Approach: Single Repository**

Create one repository that contains everything needed for the LEOS development environment.

### **Repository Structure**

```
leos-dev-environment/
├── .github/workflows/          # CI/CD pipeline
│   └── ci.yml                 # GitHub Actions workflow
├── docker/                     # Docker configurations
│   ├── development/           # Development Dockerfiles
│   └── production/            # Production Dockerfiles
├── scripts/                    # Automation scripts
│   ├── dev-start.sh          # Start development environment
│   ├── dev-stop.sh           # Stop development environment
│   ├── dev-logs.sh           # View logs
│   ├── test.sh               # Run tests
│   ├── deploy-staging.sh     # Deploy to staging
│   └── deploy-production.sh  # Deploy to production
├── docs/                       # Documentation
│   ├── development.md        # Development guide
│   ├── troubleshooting.md    # Troubleshooting guide
│   └── architecture.md       # System architecture
├── docker-compose.dev.yml      # Development environment
├── docker-compose.prod.yml     # Production environment
├── env.development             # Development environment variables
├── env.production              # Production environment variables
├── README.md                   # Main documentation
├── .gitignore                  # Git ignore rules
├── leos/                       # LEOS core (copied from your fork)
└── annotate/                   # Annotation module (copied from EU repo)
```

## 🔧 **Setup Steps**

### **Step 1: Create New Repository**

1. Go to https://github.com/TobyAbel/
2. Click "New repository"
3. Name: `leos-dev-environment`
4. Description: "LEOS Development Environment with Docker and CI/CD"
5. Make it Public (or Private if preferred)
6. Don't initialize with README (we'll copy our existing one)

### **Step 2: Initialize Local Repository**

```bash
# Navigate to your current directory
cd /Users/toby/Repositories/augmented_leos

# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: LEOS development environment setup"

# Add remote
git remote add origin https://github.com/TobyAbel/leos-dev-environment.git

# Push to GitHub
git push -u origin main
```

### **Step 3: Copy LEOS Code**

Since you already have the LEOS code in your local directory, it will be included in the repository. The structure will be:

```
leos-dev-environment/
├── leos/                       # Your LEOS fork code
│   ├── modules/
│   ├── pom.xml
│   └── ...
├── annotate/                   # EU annotate code
│   ├── client-angular/
│   ├── server/
│   └── ...
└── [all the Docker and CI/CD files we created]
```

## 🔄 **Alternative Approaches**

### **Option 2: Git Submodules**

If you want to keep the LEOS and annotate repositories separate:

```bash
# Create the main repository
git init
git remote add origin https://github.com/TobyAbel/leos-dev-environment.git

# Add LEOS as submodule
git submodule add https://github.com/TobyAbel/ocn-leos.git leos

# Add annotate as submodule (you'd need to fork it first)
git submodule add https://github.com/TobyAbel/ocn-annotate.git annotate

# Add all other files
git add .
git commit -m "Initial commit with submodules"
git push -u origin main
```

### **Option 3: Multiple Repositories**

Keep everything separate:

1. `leos-dev-environment` - Just the Docker/CI/CD setup
2. `ocn-leos` - Your existing LEOS fork
3. `ocn-annotate` - New fork of annotate repo

## 🎯 **Why Option 1 (Single Repository) is Recommended**

### **Pros:**

- ✅ **Simpler setup**: One repository to manage
- ✅ **Easier CI/CD**: All code in one place
- ✅ **Version consistency**: All components versioned together
- ✅ **Easier deployment**: Single repository to clone
- ✅ **Better documentation**: Everything in one place

### **Cons:**

- ❌ **Larger repository**: Includes all LEOS code
- ❌ **Harder to sync**: Manual updates from upstream repos
- ❌ **Less modular**: Can't easily use different versions

## 🔧 **Managing Updates**

### **From Your LEOS Fork**

```bash
# Update LEOS code from your fork
cd leos
git fetch github
git merge github/main
cd ..

# Commit the update
git add leos/
git commit -m "Update LEOS from upstream"
git push
```

### **From EU Annotate Repository**

```bash
# Update annotate code from EU repo
cd annotate
git fetch origin
git merge origin/main
cd ..

# Commit the update
git add annotate/
git commit -m "Update annotate from EU repository"
git push
```

## 🚀 **Development Workflow**

### **Local Development**

```bash
# Clone the repository
git clone https://github.com/TobyAbel/leos-dev-environment.git
cd leos-dev-environment

# Start development environment
./scripts/dev-start.sh

# Make changes to LEOS code
# Changes are automatically detected and hot-reloaded

# Commit changes
git add .
git commit -m "Update LEOS functionality"
git push
```

### **CI/CD Pipeline**

1. **Push to `main`**: Triggers automated testing
2. **Push to `staging`**: Deploys to staging environment
3. **Push to `production`**: Deploys to production environment

## 📁 **Final Directory Structure**

After setup, your local directory will look like:

```
/Users/toby/Repositories/augmented_leos/  # This becomes your leos-dev-environment repo
├── .github/workflows/
├── docker/
├── scripts/
├── docs/
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── env.development
├── env.production
├── README.md
├── .gitignore
├── leos/                    # Your LEOS code
└── annotate/                # EU annotate code
```

## 🎯 **Next Steps**

1. **Create the GitHub repository**: `https://github.com/TobyAbel/leos-dev-environment`
2. **Initialize git in your current directory**: `git init`
3. **Add remote**: `git remote add origin https://github.com/TobyAbel/leos-dev-environment.git`
4. **Push everything**: `git push -u origin main`
5. **Test the setup**: `./scripts/dev-start.sh`

This approach gives you a single, manageable repository that contains everything needed for the LEOS development environment while maintaining the ability to update from upstream sources when needed.
