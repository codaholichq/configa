# Build stage
FROM maven:3.9.4-eclipse-temurin-17-alpine@sha256:b4153285159ce6331aaa5622d1a9bac102cebc92abe68c7976bd466c814fe051 AS build
LABEL maintainer="codaholic.com"
WORKDIR /
COPY . /
RUN mvn clean install -Dmaven.test.skip=true

# Package stage
FROM amazoncorretto:17-alpine@sha256:a4ce01ba9e9b7127c33c2aa03e81b0c65a0d522b6ab92ad2491b4e7fdacae8ce
RUN apk add --no-cache dumb-init
RUN mkdir /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser

COPY --from=build /target/*.jar /app/app.jar
WORKDIR /app
RUN chown -R javauser:javauser /app
USER javauser
EXPOSE 8080
ENTRYPOINT ["dumb-init", "java", "-jar", "app.jar"]