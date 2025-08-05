# LEOS Development Environment Setup Summary

## 🎯 Overview

This repository provides a comprehensive Docker-based development environment for LEOS (Legislation Editing Open Software) with hot reloading, CI/CD pipeline, and production deployment capabilities.

## 🚀 Key Features

### ✅ Solved Pain Points

1. **Hot Reloading**:

   - Angular frontend with live browser refresh
   - Spring Boot backend with automatic restart
   - WebSocket support for real-time updates

2. **Fast Development Cycle**:

   - Local development with Docker
   - No more git push → pull → rebuild cycles
   - Instant feedback on code changes

3. **Consistent Environments**:

   - Docker containers ensure same environment across Mac/Linux
   - No more "works on my machine" issues
   - Reproducible builds

4. **Automated Testing & Deployment**:

   - GitHub Actions CI/CD pipeline
   - Automated testing on every commit
   - Staging and production deployment

5. **Comprehensive Monitoring**:
   - Prometheus + Grafana for metrics
   - Health checks for all services
   - Log aggregation and analysis

## 📁 Repository Structure

```
leos-dev-environment/
├── docker/                    # Docker configurations
│   ├── development/          # Development Dockerfiles
│   └── production/           # Production Dockerfiles
├── scripts/                  # Automation scripts
│   ├── dev-start.sh         # Start development environment
│   ├── dev-stop.sh          # Stop development environment
│   ├── dev-logs.sh          # View logs
│   ├── test.sh              # Run tests
│   ├── deploy-staging.sh    # Deploy to staging
│   └── deploy-production.sh # Deploy to production
├── docs/                    # Documentation
│   ├── development.md       # Development guide
│   ├── troubleshooting.md   # Troubleshooting guide
│   └── architecture.md      # System architecture
├── .github/workflows/       # CI/CD pipeline
│   └── ci.yml              # GitHub Actions workflow
├── docker-compose.dev.yml   # Development environment
├── docker-compose.prod.yml  # Production environment
├── env.development          # Development environment variables
├── env.production           # Production environment variables
└── README.md               # Main documentation
```

## 🏗️ Architecture

### Development Environment

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   LEOS UI       │    │  Annotation     │    │   CMIS          │
│   (Angular)     │    │  Client         │    │   Repository    │
│   Port: 4200    │    │  (Angular)      │    │   Port: 9090    │
│   Hot Reload    │    │  Port: 4201     │    │   In-Memory     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     Nginx       │
                    │   Load Balancer │
                    │   Port: 80      │
                    │   WebSocket     │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  LEOS Services  │
                    │  (Spring Boot)  │
                    │  Port: 8080     │
                    │  Hot Reload     │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │ Annotation      │
                    │ Server          │
                    │ Port: 9099      │
                    │ Hot Reload      │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Database      │
                    │   (H2/PostgreSQL)│
                    │   Port: 5432    │
                    └─────────────────┘
```

### Production Environment

- **Load Balancer**: Nginx with SSL termination
- **Application Servers**: Multiple Spring Boot instances
- **Database**: PostgreSQL with connection pooling
- **CMIS**: Chemistry OpenCMIS with persistent storage
- **Monitoring**: Prometheus + Grafana
- **Caching**: Redis for session management

## 🚀 Getting Started

### 1. Prerequisites

```bash
# Install Docker Desktop (Mac/Windows)
# Download from https://www.docker.com/products/docker-desktop

# Install Docker Engine (Linux)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Verify installation
docker --version
docker-compose --version
```

### 2. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd leos-dev-environment

# Make scripts executable
chmod +x scripts/*.sh

# Start development environment
./scripts/dev-start.sh
```

### 3. Access Applications

- **LEOS UI**: http://localhost/leos-pilot/ui/
- **Annotation Client**: http://localhost/annotate/client/
- **CMIS Repository**: http://localhost:9090/
- **H2 Database Console**: http://localhost:9094/

### 4. Development Workflow

```bash
# Start development environment
./scripts/dev-start.sh

# View logs
./scripts/dev-logs.sh

# Run tests
./scripts/test.sh

# Stop environment
./scripts/dev-stop.sh
```

## 🔧 Development Features

### Hot Reloading

1. **Frontend (Angular)**:

   - Changes to `.ts`, `.html`, `.scss` files trigger browser refresh
   - WebSocket connection for live updates
   - Source maps for debugging

2. **Backend (Spring Boot)**:
   - Spring Boot DevTools for automatic restart
   - Maven dependency auto-download
   - Configuration hot reload

### Testing

```bash
# Run all tests
./scripts/test.sh

# Backend tests only
docker-compose -f docker-compose.dev.yml exec leos-services ./mvnw test

# Frontend tests only
docker-compose -f docker-compose.dev.yml exec leos-ui npm test
```

### Debugging

1. **Backend Debugging**:

   ```bash
   # Enable remote debugging
   docker-compose -f docker-compose.dev.yml exec leos-services ./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
   ```

2. **Frontend Debugging**:
   - Use Chrome DevTools
   - Angular debugging with source maps
   - Network tab for API calls

## 🚀 Deployment

### CI/CD Pipeline

1. **Push to `main`**: Triggers automated testing
2. **Push to `staging`**: Deploys to staging environment
3. **Push to `production`**: Deploys to production environment

### Manual Deployment

```bash
# Deploy to staging
./scripts/deploy-staging.sh

# Deploy to production
./scripts/deploy-production.sh
```

### Environment Configuration

```bash
# Development
source env.development

# Production
source env.production
```

## 📊 Monitoring

### Development Monitoring

- **Docker Desktop**: Resource usage dashboard
- **Application Logs**: `docker-compose logs -f`
- **Health Checks**: Built-in health endpoints

### Production Monitoring

- **Prometheus**: Metrics collection
- **Grafana**: Dashboards and alerts
- **ELK Stack**: Log aggregation (optional)

## 🔒 Security

### Development

- Local authentication: `demo/demo`
- No SSL (localhost only)
- H2 in-memory database

### Production

- OAuth 2.0 / SAML authentication
- SSL/TLS encryption
- Database encryption at rest
- Network security groups

## 🚨 Troubleshooting

### Common Issues

1. **Docker not running**: Install Docker Desktop/Engine
2. **Port conflicts**: Check with `lsof -i :8080`
3. **Memory issues**: Increase Docker memory limit
4. **Hot reloading not working**: Rebuild containers
5. **Database connection**: Restart database service

### Getting Help

1. **Check logs**: `./scripts/dev-logs.sh`
2. **Restart environment**: `./scripts/dev-stop.sh && ./scripts/dev-start.sh`
3. **View documentation**: `docs/troubleshooting.md`

## 📈 Benefits

### For Developers

- ✅ **Fast Feedback Loop**: Hot reloading eliminates rebuild cycles
- ✅ **Consistent Environment**: Docker ensures same setup everywhere
- ✅ **Easy Debugging**: Integrated debugging tools
- ✅ **Automated Testing**: CI/CD pipeline catches issues early

### For Operations

- ✅ **Reproducible Deployments**: Docker images ensure consistency
- ✅ **Scalable Architecture**: Multiple service instances
- ✅ **Monitoring**: Comprehensive observability
- ✅ **Security**: Production-ready security measures

### For Business

- ✅ **Faster Development**: Reduced time to market
- ✅ **Higher Quality**: Automated testing and monitoring
- ✅ **Lower Costs**: Efficient resource usage
- ✅ **Better Collaboration**: Standardized development environment

## 🔄 Migration from Current Setup

### Current Pain Points → Solutions

1. **No Hot Reloading** → Docker containers with volume mounts
2. **Slow Feedback Loop** → Local development with instant updates
3. **Environment Differences** → Docker ensures consistency
4. **Manual Deployment** → Automated CI/CD pipeline
5. **No Staging Environment** → Separate staging and production environments

### Migration Steps

1. **Setup New Repository**:

   ```bash
   git clone <new-repo-url>
   cd leos-dev-environment
   ```

2. **Copy Existing Code**:

   ```bash
   cp -r ../augmented_leos/leos ./
   cp -r ../augmented_leos/annotate ./
   ```

3. **Start Development Environment**:

   ```bash
   ./scripts/dev-start.sh
   ```

4. **Verify Everything Works**:

   - Access http://localhost/leos-pilot/ui/
   - Test hot reloading
   - Run tests

5. **Deploy to Production**:
   ```bash
   ./scripts/deploy-production.sh
   ```

## 🎯 Next Steps

1. **Create GitHub Repository**: Push this setup to GitHub
2. **Configure CI/CD**: Set up GitHub Actions secrets
3. **Setup Production Environment**: Configure GCP/cloud environment
4. **Migrate Existing Data**: Export/import current data
5. **Team Training**: Document and train team on new workflow

## 📞 Support

- **Documentation**: `docs/` directory
- **Issues**: GitHub Issues
- **Architecture**: `docs/architecture.md`
- **Troubleshooting**: `docs/troubleshooting.md`

---

**🎉 Congratulations!** You now have a modern, scalable, and efficient development environment for LEOS with hot reloading, automated testing, and production deployment capabilities.
