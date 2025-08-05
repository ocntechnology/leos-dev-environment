# LEOS Development Guide

This guide covers local development setup, hot reloading, testing, and best practices for the LEOS development environment.

## 🚀 Quick Start

### Prerequisites

- **Docker Desktop** (for Mac/Windows) or **Docker Engine** (for Linux)
- **Docker Compose**
- **Git**
- **Node.js 20+** (for local development)
- **Java 8+** (for local development)

### Initial Setup

1. **Clone the repository:**

   ```bash
   git clone <your-repo-url>
   cd leos-dev-environment
   ```

2. **Start the development environment:**

   ```bash
   ./scripts/dev-start.sh
   ```

3. **Access the applications:**
   - LEOS UI: http://localhost/leos-pilot/ui/
   - Annotation Client: http://localhost/annotate/client/
   - CMIS Repository: http://localhost:9090/
   - H2 Database Console: http://localhost:9094/

## 🔧 Development Workflow

### Hot Reloading

The development environment is configured with hot reloading for both frontend and backend:

#### Frontend Hot Reloading (Angular)

- **LEOS UI**: Changes to Angular files in `leos/modules/ui-angular/` automatically trigger browser refresh
- **Annotation Client**: Changes to Angular files in `annotate/client-angular/` automatically trigger browser refresh
- **WebSocket Support**: Nginx is configured to proxy WebSocket connections for live reloading

#### Backend Hot Reloading (Spring Boot)

- **Spring Boot DevTools**: Automatically restarts the application when Java files change
- **Maven Dependencies**: Automatically downloads new dependencies
- **Configuration Changes**: Automatically reloads application properties

### Development Commands

```bash
# Start development environment
./scripts/dev-start.sh

# Stop development environment
./scripts/dev-stop.sh

# View logs
./scripts/dev-logs.sh [service-name]

# Run tests
./scripts/test.sh

# Rebuild specific service
docker-compose -f docker-compose.dev.yml build leos-services
docker-compose -f docker-compose.dev.yml up -d leos-services
```

### Service Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   LEOS UI       │    │  Annotation     │    │   CMIS          │
│   (Angular)     │    │  Client         │    │   Repository    │
│   Port: 4200    │    │  (Angular)      │    │   Port: 9090    │
│                 │    │  Port: 4201     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     Nginx       │
                    │   Load Balancer │
                    │   Port: 80      │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  LEOS Services  │
                    │  (Spring Boot)  │
                    │  Port: 8080     │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │ Annotation      │
                    │ Server          │
                    │ Port: 9099      │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Database      │
                    │   (H2/PostgreSQL)│
                    │   Port: 5432    │
                    └─────────────────┘
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
./scripts/test.sh

# Run backend tests only
docker-compose -f docker-compose.dev.yml exec leos-services ./mvnw test

# Run frontend tests only
docker-compose -f docker-compose.dev.yml exec leos-ui npm test

# Run annotation tests only
docker-compose -f docker-compose.dev.yml exec annotate-server ./mvnw test
docker-compose -f docker-compose.dev.yml exec annotate-client npm test
```

### Test Coverage

- **Backend**: JUnit tests with Spring Boot Test
- **Frontend**: Jasmine/Karma tests with Angular CLI
- **Integration**: End-to-end tests with Cypress
- **API**: REST API tests with REST Assured

## 🔍 Debugging

### Backend Debugging

1. **Enable Debug Mode:**

   ```bash
   docker-compose -f docker-compose.dev.yml exec leos-services ./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
   ```

2. **Attach Debugger:**
   - IDE: Configure remote debugging on localhost:5005
   - VS Code: Use the Java Debug extension

### Frontend Debugging

1. **Browser Developer Tools:**

   - Open Chrome DevTools (F12)
   - Use Sources tab for breakpoints
   - Use Console for logging

2. **Angular Debugging:**
   ```bash
   # Enable Angular debugging
   docker-compose -f docker-compose.dev.yml exec leos-ui npm run start-local -- --configuration=development
   ```

### Database Debugging

1. **H2 Console:**

   - Access: http://localhost:9094/
   - JDBC URL: `jdbc:h2:mem:leos`
   - Username: `leos`
   - Password: `leos123`

2. **PostgreSQL:**
   ```bash
   # Connect to database
   docker-compose -f docker-compose.dev.yml exec database psql -U leos -d leos
   ```

## 📊 Monitoring

### Application Logs

```bash
# View all logs
docker-compose -f docker-compose.dev.yml logs -f

# View specific service logs
docker-compose -f docker-compose.dev.yml logs -f leos-services
docker-compose -f docker-compose.dev.yml logs -f leos-ui
docker-compose -f docker-compose.dev.yml logs -f annotate-server
```

### Health Checks

```bash
# Check LEOS Services
curl http://localhost:8080/actuator/health

# Check Annotation Server
curl http://localhost:9099/health

# Check CMIS Repository
curl http://localhost:9090/chemistry-opencmis-server-inmemory/

# Check Nginx
curl http://localhost/health
```

### Performance Monitoring

- **Docker Desktop**: Use the Docker Desktop dashboard for resource usage
- **Application Metrics**: Spring Boot Actuator provides metrics at `/actuator/metrics`
- **Database Monitoring**: Use H2 console or PostgreSQL tools

## 🔧 Configuration

### Environment Variables

The development environment uses the following key environment variables:

```bash
# Load development environment
source env.development

# Or set individually
export LEOS_ENVIRONMENT=development
export LEOS_DB_URL=jdbc:h2:mem:leos
export LEOS_CMIS_URL=http://cmis-repository:8080/chemistry-opencmis-server-inmemory
export ANNOTATE_SERVER_URL=http://annotate-server:9099
```

### Docker Compose Overrides

You can create a `docker-compose.override.yml` file for local customizations:

```yaml
version: "3.8"
services:
  leos-services:
    environment:
      - DEBUG=true
      - LOG_LEVEL=TRACE
    volumes:
      - ./local-config:/app/config
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Port Conflicts

```bash
# Check what's using a port
lsof -i :8080

# Kill process using port
sudo kill -9 $(lsof -t -i:8080)
```

#### 2. Docker Issues

```bash
# Clean up Docker
docker system prune -a

# Restart Docker Desktop
# (On Mac/Windows, restart Docker Desktop application)
```

#### 3. Memory Issues

```bash
# Increase Docker memory limit
# In Docker Desktop settings, increase memory allocation to 8GB+
```

#### 4. Hot Reloading Not Working

```bash
# Rebuild containers
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml up -d --build

# Check file permissions
ls -la leos/modules/ui-angular/
```

#### 5. Database Connection Issues

```bash
# Restart database
docker-compose -f docker-compose.dev.yml restart database

# Check database logs
docker-compose -f docker-compose.dev.yml logs database
```

### Performance Optimization

1. **Docker Resources:**

   - Allocate at least 8GB RAM to Docker
   - Allocate at least 4 CPU cores to Docker

2. **IDE Settings:**

   - Exclude `node_modules` and `target` directories from indexing
   - Use `.gitignore` patterns for IDE files

3. **Browser Performance:**
   - Disable browser extensions during development
   - Use Chrome DevTools Performance tab for profiling

## 📚 Best Practices

### Code Organization

1. **Follow Angular Style Guide:**

   - Use Angular CLI for component generation
   - Follow naming conventions
   - Use TypeScript strict mode

2. **Follow Spring Boot Best Practices:**

   - Use Spring Boot DevTools for development
   - Implement proper exception handling
   - Use Spring Boot Actuator for monitoring

3. **Git Workflow:**

   ```bash
   # Create feature branch
   git checkout -b feature/your-feature-name

   # Make changes and commit
   git add .
   git commit -m "feat: add your feature"

   # Push to remote
   git push origin feature/your-feature-name

   # Create pull request
   # (Use GitHub/GitLab web interface)
   ```

### Testing Best Practices

1. **Unit Tests:**

   - Write tests for all business logic
   - Use meaningful test names
   - Follow AAA pattern (Arrange, Act, Assert)

2. **Integration Tests:**

   - Test API endpoints
   - Test database interactions
   - Use test containers for external services

3. **End-to-End Tests:**
   - Test critical user journeys
   - Use page object pattern
   - Keep tests independent

### Security Best Practices

1. **Development:**

   - Use environment variables for secrets
   - Don't commit sensitive data
   - Use HTTPS in production

2. **Authentication:**
   - Use demo/demo for development
   - Implement proper authentication in production
   - Use JWT tokens for API access

## 🔗 Useful Links

- [LEOS Documentation](https://interoperable-europe.ec.europa.eu/collection/justice-law-and-security/solution/leos-open-source-software-editing-legislation)
- [Angular Development Guide](https://angular.io/guide/development-workflow)
- [Spring Boot Development Guide](https://spring.io/guides/gs/spring-boot/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [AkomaNtoso Documentation](https://www.akomantoso.org/)
