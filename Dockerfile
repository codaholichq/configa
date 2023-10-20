# Build stage
FROM maven:3.9.5-eclipse-temurin-21-alpine@sha256:7b4c4ff7e066658ade018542494add4db8b871aebb0aeedd0cf016f75c36084b AS build
LABEL maintainer="codaholic.com"
WORKDIR /app
COPY pom.xml .
COPY src src

RUN --mount=type=cache,target=/root/.m2 mvn install -Dmaven.test.skip=true
RUN mkdir -p target/deps && (cd target/deps; jar -xf ../libs/*-0.0.1.jar)

# Package stage
FROM amazoncorretto:17-alpine@sha256:0770cab734f259b1f68060bd543aab1e217f1634d7bbac76c09996a1a9bf723b
RUN apk add --no-cache dumb-init
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser

VOLUME /tmp
ARG DEPS=/app/target/deps
COPY --from=build ${DEPS}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPS}/META-INF /app/META-INF
COPY --from=build ${DEPS}/BOOT-INF/classes /app

RUN chown -R javauser:javauser /app
USER javauser
EXPOSE 8080
ENTRYPOINT ["dumb-init", "java", "-cp", "app:app/lib/*", "configa.Application"]
