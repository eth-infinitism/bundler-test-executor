FROM node:18 as aa07
RUN git clone http://github.com/eth-infinitism/account-abstraction.git -b v0.7.0
WORKDIR account-abstraction
ENV TS_NODE_TRANSPILE_ONLY=1
ENV PATH=$PATH:./node_modules/.bin
RUN yarn global add node-gyp
RUN yarn && hardhat compile

FROM ghcr.io/foundry-rs/foundry:latest

RUN apk add jq
# RUN apk add nodejs yarn jq perl
# RUN echo 'sh "$@"' > /bin/bash && chmod a+rx /bin/bash
# RUN git clone http://github.com/eth-infinitism/account-abstraction.git -b v0.7.0
# RUN cd account-abstraction && yarn 
# ENV TS_NODE_TRANSPILE_ONLY=1
# ENV PATH=$PATH:./node_modules/.bin
# RUN cd account-abstraction && hardhat compile
# ADD external-conf.ts account-abstraction/
WORKDIR account-abstraction
ENTRYPOINT  [ "/bin/sh", "-c" ]
ADD . .
COPY --from=aa07 /account-abstraction/artifacts artifacts
CMD [ "./deploy-entrypoint.sh" ]

#alternate deployment, using hardhat deploy (external-conf.ts uses ETH_RPC_URL env. var to connect)
#CMD [ "hardhat --config external-conf.ts deploy" ]
