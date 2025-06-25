# Stage 1: Development
FROM maven:3.9.10-eclipse-temurin-17 AS development

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean test


# Stage 2: build
FROM maven:3.9.10-eclipse-temurin-17 AS build    

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 3: Production
FROM openjdk:17
WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy JAR file from build stage
COPY --from=build /app/target/*.jar backend-service.jar

# Create non-root user for security
RUN addgroup --system spring && adduser --system spring --ingroup spring
RUN chown -R spring:spring /app
USER spring:spring

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "backend-service.jar"]