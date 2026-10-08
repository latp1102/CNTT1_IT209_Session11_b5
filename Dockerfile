FROM gradle:8.5-jdk17-alpine AS builder
WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
COPY src/ src/
COPY gradlew ./

RUN chmod +x gradlew && ./gradlew bootJar --no-daemon -x test

FROM amazoncorretto:17-alpine-jdk
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /app/build/libs/*.jar /app/app.jar
RUN chown appuser:appgroup /app/app.jar

USER appuser

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
