# ══════════════════════════════════════════════════════════════════════════════
# Fatwa API Gateway — Multi-stage Dockerfile (Java 25, Eclipse Temurin)
# ══════════════════════════════════════════════════════════════════════════════

# ── Stage 1: Build ────────────────────────────────────────────────────────────
FROM eclipse-temurin:25-jdk AS build

WORKDIR /workspace

# Copy Gradle wrapper and build files first (layer caching)
COPY gradle/               gradle/
COPY gradlew               gradlew
COPY build.gradle           build.gradle
COPY settings.gradle        settings.gradle

# Download dependencies (cached unless build files change)
RUN chmod +x gradlew && ./gradlew dependencies --no-daemon

# Copy source and build
COPY src/ src/
RUN ./gradlew bootJar --no-daemon -x test

# ── Stage 2: Runtime ─────────────────────────────────────────────────────────
FROM eclipse-temurin:25-jre AS runtime

LABEL maintainer="Fatwa AI <dev@fatwa.ai>"
LABEL description="Fatwa API Gateway"

# Security: run as non-root
RUN groupadd --system appgroup && useradd --system --gid appgroup appuser

WORKDIR /app

# Copy the fat JAR from the build stage
COPY --from=build /workspace/build/libs/*.jar app.jar

# Set ownership
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

# JVM flags optimized for containers with virtual threads
ENTRYPOINT ["java", \
    "-XX:+UseZGC", \
    "-XX:+ZGenerational", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "-jar", "app.jar"]
