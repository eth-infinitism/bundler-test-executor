FROM node:18 AS aabuild
RUN git clone http://github.com/eth-infinitism/account-abstraction.git -b v0.8.0
WORKDIR account-abstraction
ENV TS_NODE_TRANSPILE_ONLY=1
ENV PATH=$PATH:./node_modules/.bin
RUN yarn global add node-gyp
RUN yarn && hardhat compile

FROM ghcr.io/foundry-rs/foundry:v0.2.0

RUN apk add jq
WORKDIR account-abstraction
ENTRYPOINT  [ "/bin/sh", "-c" ]
ADD . .
COPY --from=aabuild /account-abstraction/artifacts artifacts
CMD [ "./deploy-entrypoint.sh" ]

#alternate deployment, using hardhat deploy (external-conf.ts uses ETH_RPC_URL env. var to connect)
#CMD [ "hardhat --config external-conf.ts deploy" ]
