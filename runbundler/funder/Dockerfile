FROM alpine AS tools
RUN apk add --no-cache jq

FROM ghcr.io/foundry-rs/foundry:v1.0.0

COPY --from=tools /usr/bin/jq /usr/bin/jq
ADD funder.sh /
#RUN chmod a+rx /funder.sh
ENTRYPOINT  [ "/funder.sh"  ]
