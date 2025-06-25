# Stage 1: Development
FROM maven:3.9.9-jdk-17 AS Development

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean test


# Stage 2: build
FROM maven:3.9.9-jdk-17 AS Build    

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 3: Production
FROM openjdk:17

# Create a non-root user
RUN useradd --create-home appuser

# Switch to the non-root user
USER appuser

ARG JAR_FILE=target/*.jar

COPY ${JAR_FILE} backend-service.jar

ENTRYPOINT ["java", "-jar", "backend-service.jar"]

EXPOSE 8080