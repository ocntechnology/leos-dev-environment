# LEOS Development Environment

A comprehensive development and production environment for LEOS (Legislation Editing Open Software) with Docker-based local development and CI/CD pipeline using a **multiple repository approach**.

## 🏗️ **Repository Structure**

This project uses a **multiple repository approach** for better modularity and separation of concerns:

```
GitHub Organization: @TobyAbel/

├── leos-dev-environment/          # Main orchestration repository (this repo)
│   ├── .github/workflows/        # CI/CD pipeline
│   ├── docker/                   # Docker configurations
│   ├── scripts/                  # Automation scripts
│   ├── docs/                     # Documentation
│   ├── docker-compose.dev.yml    # Development environment
│   ├── docker-compose.prod.yml   # Production environment
│   └── README.md                 # This file
│
├── ocn-leos/                     # LEOS core application
│   ├── modules/
│   ├── pom.xml
│   └── ... (all LEOS code)
│
└── ocn-annotate/                 # Annotation module
    ├── client-angular/
    ├── server/
    └── ... (all annotate code)
```

## 🚀 **Quick Start**

### **Prerequisites**

- Docker Desktop (for Mac/Windows) or Docker Engine (for Linux)
- Docker Compose
- Git
- Node.js 20+ (for local development)
- Java 8+ (for local development)

### **Setup**

1. **Clone this repository:**
   ```bash
   git clone https://github.com/TobyAbel/leos-dev-environment.git
   cd leos-dev-environment
   ```

2. **Run the setup script:**
   ```bash
   ./scripts/setup.sh
   ```
   This will automatically clone the required repositories:
   - `leos/` - LEOS core application
   - `annotate/` - Annotation module

3. **Start the development environment:**
   ```bash
   ./scripts/dev-start.sh
   ```

4. **Access the applications:**
   - LEOS UI: http://localhost/leos-pilot/ui/
   - Annotation Client: http://localhost/annotate/client/
   - CMIS Repository: http://localhost:9090/
   - H2 Database Console: http://localhost:9094/

## 🔧 **Development Workflow**

### **Local Development**

```bash
# Start development environment with hot reloading
./scripts/dev-start.sh

# View logs
./scripts/dev-logs.sh

# Run tests
./scripts/test.sh

# Stop environment
./scripts/dev-stop.sh
```

### **Repository Management**

```bash
# Check status of all repositories
./scripts/status.sh

# Update all repositories to latest versions
./scripts/update.sh

# Setup repositories (if missing)
./scripts/setup.sh
```

## 🏗️ **Architecture**

### **Development Environment**

- **Frontend**: Angular 18+ with hot reloading
- **Backend**: Spring Boot with hot reloading
- **Database**: H2 (development) / PostgreSQL (staging/production)
- **CMIS**: Chemistry OpenCMIS in-memory
- **Annotations**: Separate Angular application

### **Production Environment**

- **Load Balancer**: Nginx
- **Application Servers**: Multiple Spring Boot instances
- **Database**: PostgreSQL with connection pooling
- **CMIS**: Chemistry OpenCMIS with persistent storage
- **Monitoring**: Prometheus + Grafana

## 🔄 **Contributing to Upstream**

### **Contributing to LEOS Core**

```bash
# Work in LEOS repository
cd leos

# Make changes
# ... edit files ...

# Commit to your fork
git add .
git commit -m "feat: add new LEOS feature"
git push origin main

# Create pull request to EU repository
# Go to: https://github.com/TobyAbel/ocn-leos
# Create PR to: https://code.europa.eu/leos/core
```

### **Contributing to Annotate**

```bash
# Work in annotate repository
cd annotate

# Make changes
# ... edit files ...

# Commit to your fork
git add .
git commit -m "feat: add new annotation feature"
git push origin main

# Create pull request to EU repository
# Go to: https://github.com/TobyAbel/ocn-annotate
# Create PR to: https://code.europa.eu/leos/annotate
```

### **Contributing to Development Environment**

```bash
# Work in main repository
cd leos-dev-environment

# Make changes to Docker configs, scripts, etc.
# ... edit files ...

# Commit and push
git add .
git commit -m "feat: improve Docker development setup"
git push origin main
```

## 🚀 **Deployment**

### **CI/CD Pipeline**

1. **Push to `main`**: Triggers automated testing
2. **Push to `staging`**: Deploys to staging environment
3. **Push to `production`**: Deploys to production environment

### **Manual Deployment**

```bash
# Deploy to staging
./scripts/deploy-staging.sh

# Deploy to production
./scripts/deploy-production.sh
```

## 📊 **Monitoring**

### **Development**

- Application logs: `docker-compose logs -f`
- Database logs: `docker-compose logs -f database`
- Performance: Docker Desktop metrics

### **Production**

- Application monitoring: Prometheus + Grafana
- Log aggregation: ELK Stack
- Health checks: Kubernetes probes

## 🔒 **Security**

### **Development**

- Local authentication: demo/demo
- No SSL (localhost only)
- H2 in-memory database

### **Production**

- OAuth 2.0 / SAML authentication
- SSL/TLS encryption
- Database encryption at rest
- Network security groups

## 📚 **Documentation**

- [Development Guide](./docs/development.md)
- [Troubleshooting](./docs/troubleshooting.md)
- [System Architecture](./docs/architecture.md)

## 🚨 **Troubleshooting**

### **Common Issues**

1. **Repositories not found**: Run `./scripts/setup.sh`
2. **Docker not running**: Start Docker Desktop
3. **Port conflicts**: Check with `lsof -i :8080`
4. **Hot reloading not working**: Rebuild containers

### **Getting Help**

1. **Check status**: `./scripts/status.sh`
2. **View logs**: `./scripts/dev-logs.sh`
3. **Restart environment**: `./scripts/dev-stop.sh && ./scripts/dev-start.sh`
4. **Update repositories**: `./scripts/update.sh`

## 📈 **Benefits of Multiple Repository Approach**

### **✅ Advantages**

- **Modularity**: Each component can evolve independently
- **Clear separation**: Development environment vs application code
- **Independent versioning**: Each repo can have its own release cycle
- **Focused contributions**: Easy to contribute to specific components
- **Reduced complexity**: Smaller, focused repositories

### **🔄 Workflow Benefits**

- **Parallel development**: Work on different components simultaneously
- **Independent testing**: Test each component separately
- **Clear ownership**: Each repository has a clear purpose
- **Easier maintenance**: Update components independently

## 🎯 **Repository URLs**

- **Main Repository**: https://github.com/TobyAbel/leos-dev-environment
- **LEOS Repository**: https://github.com/TobyAbel/ocn-leos
- **Annotate Repository**: https://github.com/TobyAbel/ocn-annotate

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## 📄 **License**

This project is licensed under the EUPL-1.2 License.

## 🆘 **Support**

- [Issues](https://github.com/TobyAbel/leos-dev-environment/issues)
- [Documentation](./docs/)
- [Architecture Diagram](./docs/architecture.md)
