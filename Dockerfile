FROM swipl:latest

USER root

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev

RUN useradd -ms /bin/bash prologuser234r

USER prologuser234r

COPY *.pl /app/

WORKDIR /app

CMD ["swipl", "-s", "plant_care_server.pl", "--", "--fork=false", "--debug=server"]
