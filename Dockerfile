# Build stage
FROM gradle:8-alpine@sha256:2c45bb3c3076531fa7dccc97db01c605c5332de411079d9cd38d1d1552b24e09 AS build
LABEL maintainer="codaholic.com"
WORKDIR /app
COPY . /

RUN gradle clean build --no-daemon -x test

# Package stage
FROM amazoncorretto:17-alpine@sha256:a4ce01ba9e9b7127c33c2aa03e81b0c65a0d522b6ab92ad2491b4e7fdacae8ce
VOLUME /tmp
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser

COPY --from=build /target/libs/*.jar /app/app.jar
RUN chown -R javauser:javauser /app
USER javauser

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]