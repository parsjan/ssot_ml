FROM openjdk:17


RUN apt-get update && apt-get install -y maven


COPY . /app
WORKDIR /app
RUN mvn install