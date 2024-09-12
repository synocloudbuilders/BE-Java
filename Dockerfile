FROM bitnami/java:17-debian-12 AS build
# RUN apt update -y
WORKDIR /helloworld
COPY ./mvnw .
COPY ./.mvn ./.mvn
COPY pom.xml .
RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline

COPY . .
RUN ./mvnw clean install

FROM bitnami/java:17-debian-12
WORKDIR /helloworld
COPY --from=build /helloworld/target/application.jar .
ENTRYPOINT [ "java","-jar","application.jar" ]