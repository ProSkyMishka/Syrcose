FROM swipl:latest

USER root

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev

COPY plant_care_server.pl /app/plant_care_server.pl

WORKDIR /app

CMD ["swipl", "-s", "plant_care_server.pl", "-g", "start_server"]
