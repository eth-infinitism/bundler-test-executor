FROM ubuntu
RUN apt update && apt install -y curl
RUN apt install -y inetutils-ping
ADD ./waitForBundler /waitForBundler

ENTRYPOINT [ "/waitForBundler" ]
