# LEOS Troubleshooting Guide

This guide covers common issues and their solutions for the LEOS development environment.

## 🚨 Common Issues

### 1. Docker Issues

#### Problem: Docker not running

**Symptoms:**

- `docker: command not found`
- `Cannot connect to the Docker daemon`

**Solutions:**

```bash
# Install Docker Desktop (Mac/Windows)
# Download from https://www.docker.com/products/docker-desktop

# Install Docker Engine (Linux)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Start Docker service (Linux)
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group (Linux)
sudo usermod -aG docker $USER
# Log out and back in
```

#### Problem: Docker Compose not found

**Symptoms:**

- `docker-compose: command not found`

**Solutions:**

```bash
# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Or use Docker Compose plugin (Docker Desktop includes this)
docker compose up -d
```

#### Problem: Port conflicts

**Symptoms:**

- `Bind for 0.0.0.0:8080 failed: port is already allocated`
- Services not accessible on expected ports

**Solutions:**

```bash
# Check what's using the port
lsof -i :8080

# Kill process using port
sudo kill -9 $(lsof -t -i:8080)

# Or change port in docker-compose.dev.yml
ports:
  - "8081:8080"  # Use port 8081 instead of 8080
```

### 2. Memory Issues

#### Problem: Out of memory errors

**Symptoms:**

- `java.lang.OutOfMemoryError: Java heap space`
- `Killed` messages in logs
- Slow performance

**Solutions:**

```bash
# Increase Docker memory limit
# Docker Desktop: Settings > Resources > Memory > 8GB+

# Increase JVM heap size
JAVA_OPTS="-Xmx4g -Xms2g"

# Check memory usage
docker stats

# Clean up Docker
docker system prune -a
```

#### Problem: Maven build fails due to memory

**Symptoms:**

- `[ERROR] Failed to execute goal on project leos-web-os`
- Build process killed

**Solutions:**

```bash
# Increase Maven memory
export MAVEN_OPTS="-Xmx2g -Xms1g"

# Use Maven wrapper with memory settings
./mvnw clean install -Dmaven.test.skip=true -Xmx2g
```

### 3. Hot Reloading Issues

#### Problem: Frontend hot reloading not working

**Symptoms:**

- Changes to Angular files don't trigger browser refresh
- WebSocket connection errors

**Solutions:**

```bash
# Rebuild Angular container
docker-compose -f docker-compose.dev.yml build leos-ui
docker-compose -f docker-compose.dev.yml up -d leos-ui

# Check file permissions
ls -la leos/modules/ui-angular/

# Check WebSocket proxy in nginx
docker-compose -f docker-compose.dev.yml logs nginx

# Restart all services
./scripts/dev-stop.sh
./scripts/dev-start.sh
```

#### Problem: Backend hot reloading not working

**Symptoms:**

- Changes to Java files don't restart Spring Boot
- `spring.devtools.restart.enabled=true` not working

**Solutions:**

```bash
# Rebuild Spring Boot container
docker-compose -f docker-compose.dev.yml build leos-services
docker-compose -f docker-compose.dev.yml up -d leos-services

# Check Spring Boot DevTools
docker-compose -f docker-compose.dev.yml exec leos-services ./mvnw spring-boot:run

# Verify DevTools dependency in pom.xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
</dependency>
```

### 4. Database Issues

#### Problem: Database connection failed

**Symptoms:**

- `java.sql.SQLException: Connection refused`
- `org.h2.jdbc.JdbcSQLException: Database not found`

**Solutions:**

```bash
# Restart database
docker-compose -f docker-compose.dev.yml restart database

# Check database logs
docker-compose -f docker-compose.dev.yml logs database

# Check database health
docker-compose -f docker-compose.dev.yml exec database pg_isready -U leos

# Recreate database volume
docker-compose -f docker-compose.dev.yml down -v
docker-compose -f docker-compose.dev.yml up -d database
```

#### Problem: H2 database not accessible

**Symptoms:**

- Can't access H2 console at http://localhost:9094/
- Database connection errors

**Solutions:**

```bash
# Check H2 container
docker-compose -f docker-compose.dev.yml logs h2-database

# Restart H2 database
docker-compose -f docker-compose.dev.yml restart h2-database

# Access H2 console directly
docker-compose -f docker-compose.dev.yml exec h2-database java -cp h2.jar org.h2.tools.Server -web
```

### 5. Network Issues

#### Problem: Services can't communicate

**Symptoms:**

- `Connection refused` errors
- Services not accessible from other containers

**Solutions:**

```bash
# Check Docker network
docker network ls
docker network inspect leos-dev_leos-network

# Restart network
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml up -d

# Check service discovery
docker-compose -f docker-compose.dev.yml exec leos-services ping annotate-server
```

#### Problem: Nginx proxy issues

**Symptoms:**

- 502 Bad Gateway errors
- Services not accessible through nginx

**Solutions:**

```bash
# Check nginx configuration
docker-compose -f docker-compose.dev.yml exec nginx nginx -t

# Restart nginx
docker-compose -f docker-compose.dev.yml restart nginx

# Check nginx logs
docker-compose -f docker-compose.dev.yml logs nginx

# Test direct service access
curl http://localhost:8080/actuator/health
curl http://localhost:4200/
```

### 6. Build Issues

#### Problem: Maven build fails

**Symptoms:**

- `[ERROR] Failed to execute goal`
- Dependency resolution errors

**Solutions:**

```bash
# Clean Maven cache
rm -rf ~/.m2/repository/eu/europa/ec/leos/pilot/leos-ui-angular

# Force update dependencies
cd leos
./mvnw clean install -U

# Check Maven version
./mvnw --version

# Use specific Java version
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

#### Problem: npm/yarn build fails

**Symptoms:**

- `npm ERR! code ENOTEMPTY`
- `yarn install` fails

**Solutions:**

```bash
# Clean npm cache
npm cache clean --force

# Remove node_modules
rm -rf leos/modules/ui-angular/node_modules
rm -rf annotate/client-angular/node_modules

# Reinstall dependencies
cd leos/modules/ui-angular
npm install --legacy-peer-deps

cd ../../annotate/client-angular
npm install --legacy-peer-deps

# Use yarn instead of npm
yarn install
```

### 7. Node.js Issues

#### Problem: Node version conflicts

**Symptoms:**

- `EBADENGINE Unsupported engine`
- Angular CLI version issues

**Solutions:**

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc

# Install Node.js 20
nvm install 20
nvm use 20

# Verify Node.js version
node --version
npm --version

# Update Angular CLI
npm install -g @angular/cli@latest
```

### 8. Java Issues

#### Problem: Java version conflicts

**Symptoms:**

- `UnsupportedClassVersionError`
- Maven compilation errors

**Solutions:**

```bash
# Check Java version
java -version
javac -version

# Install Java 8
sudo apt update
sudo apt install openjdk-8-jdk

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Verify Java version
java -version
```

### 9. SSL/HTTPS Issues

#### Problem: SSL certificate errors

**Symptoms:**

- `SSL certificate verify failed`
- HTTPS connection errors

**Solutions:**

```bash
# For development, use HTTP
# Update environment variables
export LEOS_API_URL=http://localhost:8080
export ANNOTATE_SERVER_URL=http://localhost:9099

# For production, ensure SSL certificates are valid
# Check certificate expiration
openssl x509 -in /path/to/certificate.crt -text -noout
```

### 10. Performance Issues

#### Problem: Slow startup times

**Symptoms:**

- Services take a long time to start
- High CPU/memory usage

**Solutions:**

```bash
# Increase Docker resources
# Docker Desktop: Settings > Resources > Advanced
# - CPUs: 4+
# - Memory: 8GB+
# - Swap: 2GB+

# Optimize JVM settings
JAVA_OPTS="-Xmx2g -Xms1g -XX:+UseG1GC"

# Use volume mounts for faster builds
volumes:
  - ./leos:/app
  - maven_cache:/root/.m2
```

#### Problem: Slow hot reloading

**Symptoms:**

- File changes take a long time to reflect
- Browser refresh is slow

**Solutions:**

```bash
# Exclude unnecessary files from watching
# In angular.json
"watch": {
  "ignored": [
    "**/node_modules/**",
    "**/dist/**",
    "**/.git/**"
  ]
}

# Use polling for file system events
# In docker-compose.dev.yml
environment:
  - CHOKIDAR_USEPOLLING=true
```

## 🔧 Diagnostic Commands

### System Information

```bash
# Docker version
docker --version
docker-compose --version

# System resources
free -h
df -h
top

# Network connectivity
ping google.com
nslookup leos.opencouncil.network
```

### Service Health Checks

```bash
# Check all services
docker-compose -f docker-compose.dev.yml ps

# Check service logs
docker-compose -f docker-compose.dev.yml logs -f [service-name]

# Check service health
curl -f http://localhost:8080/actuator/health
curl -f http://localhost:9099/health
curl -f http://localhost/health
```

### Performance Monitoring

```bash
# Docker stats
docker stats

# Container resource usage
docker-compose -f docker-compose.dev.yml exec leos-services top

# Network connections
netstat -tulpn | grep :8080
```

## 🆘 Getting Help

### Before Asking for Help

1. **Check the logs:**

   ```bash
   docker-compose -f docker-compose.dev.yml logs -f
   ```

2. **Verify your environment:**

   ```bash
   # Check Docker
   docker info

   # Check system resources
   free -h
   df -h

   # Check network
   ping -c 3 google.com
   ```

3. **Try the basic troubleshooting steps:**

   ```bash
   # Restart everything
   ./scripts/dev-stop.sh
   ./scripts/dev-start.sh

   # Check if services are running
   docker-compose -f docker-compose.dev.yml ps
   ```

### When Reporting Issues

Include the following information:

1. **Environment details:**

   - Operating system and version
   - Docker version
   - Node.js version
   - Java version

2. **Error messages:**

   - Full error output
   - Log files
   - Screenshots if applicable

3. **Steps to reproduce:**

   - Exact commands run
   - Expected vs actual behavior

4. **System information:**
   - Available memory
   - Disk space
   - CPU usage

### Useful Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Spring Boot Troubleshooting](https://spring.io/guides/gs/spring-boot/)
- [Angular Troubleshooting](https://angular.io/guide/troubleshooting)
- [LEOS Documentation](https://interoperable-europe.ec.europa.eu/collection/justice-law-and-security/solution/leos-open-source-software-editing-legislation)
