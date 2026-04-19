# Stage 1: Build
FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

# Copy gradle wrapper and configuration
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# Pre-download dependencies to speed up subsequent builds
RUN ./gradlew build -x test --stacktrace || return 0

# Copy source and build the JAR
COPY src src
RUN ./gradlew clean bootJar -x test

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Security: Run as a non-privileged user
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Copy only the built JAR from the previous stage
COPY --from=build /app/build/libs/*.jar app.jar

# Inform Docker that the container listens on 9091
EXPOSE 9092

# Optimization for K8s/Containers
ENTRYPOINT ["java", \
            "-XX:+UseContainerSupport", \
            "-XX:MaxRAMPercentage=75.0", \
            "-Djava.security.egd=file:/dev/./urandom", \
            "-jar", \
            "app.jar"]