# Build stage
FROM gradle:8-alpine@sha256:2c45bb3c3076531fa7dccc97db01c605c5332de411079d9cd38d1d1552b24e09 AS build
LABEL maintainer="codaholic.com"
WORKDIR /app
COPY build.gradle .
COPY settings.gradle .
COPY src src

RUN --mount=type=cache,target=/root/.m2 gradle build --no-daemon -x test
RUN mkdir -p target/deps && (cd target/deps; jar -xf ../libs/*-0.0.1.jar)

# Package stage
FROM amazoncorretto:17-alpine@sha256:a4ce01ba9e9b7127c33c2aa03e81b0c65a0d522b6ab92ad2491b4e7fdacae8ce
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
ENTRYPOINT ["dumb-init", "java","-cp","app:app/lib/*","codaholic.configa.Application"]
