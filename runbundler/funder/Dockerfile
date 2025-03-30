FROM ghcr.io/foundry-rs/foundry:v0.2.0

RUN apk add jq
ADD funder.sh /
#RUN chmod a+rx /funder.sh
ENTRYPOINT  [ "/funder.sh"  ]
