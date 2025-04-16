FROM accountabstraction/foundry-legacy-0.2
#latest foundry image doesn't support "apk" 
RUN apk add --no-cache jq

ADD funder.sh /
#RUN chmod a+rx /funder.sh
ENTRYPOINT  [ "/funder.sh"  ]
