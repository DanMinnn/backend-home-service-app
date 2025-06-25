# Docker Guide for Home Service Project

## Prerequisites
- Install Docker: https://docs.docker.com/get-docker/
- Install Docker Compose: https://docs.docker.com/compose/install/

## Building and Running the Application

1. **Build the application JAR file**:
   ```bash
   ./mvnw clean package -DskipTests
   ```

2. **Start all containers**:
   ```bash
   docker-compose up -d
   ```
   This will start PostgreSQL, Redis, and the backend service.

3. **Check running containers**:
   ```bash
   docker-compose ps
   ```

4. **View logs**:
   ```bash
   # All services
   docker-compose logs

   # Specific service
   docker-compose logs backend-service
   ```

5. **Stop the services**:
   ```bash
   docker-compose down
   ```

## Development Workflow

When making changes to the application:

1. Build a new JAR file:
   ```bash
   ./mvnw clean package -DskipTests
   ```

2. Rebuild and restart the backend container:
   ```bash
   docker-compose up -d --build backend-service
   ```

## Troubleshooting

- **Database connection issues**: Verify PostgreSQL is running with `docker-compose ps` and check the connection string in the environment variables.
- **Redis connectivity**: Ensure Redis is running and the backend service can reach it on the backend network.
- **Container not starting**: Check logs with `docker-compose logs [service-name]`.

## Data Persistence

PostgreSQL data is persisted in a named volume called `postgres`. If you need to start with a clean database:

```bash
docker-compose down
docker volume rm home-service_postgres
docker-compose up -d
```

## Accessing Services

- Backend API: http://localhost:8080
- PostgreSQL: localhost:5432 (from host) or postgres:5432 (from other containers)
- Redis: localhost:6379 (from host) or redis:6379 (from other containers)
