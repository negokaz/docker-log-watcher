FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y \
      curl \
  && rm -rf /var/lib/apt/lists/*

ADD log-watch.sh /usr/local/bin

RUN chmod +x /usr/local/bin/log-watch.sh \
  && touch /target

ENTRYPOINT ["log-watch.sh"]
