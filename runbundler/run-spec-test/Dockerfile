#NOTE: build with:
# DOCKER_DEFAULT_PLATFORM=linux/amd64 
# docker build -t runtest ../.. -f ./Dockerfile"
# (or from docker-compose file run-spec-test.yml)
FROM python:3.11.7-slim-bullseye
RUN pip install --upgrade pip
COPY bundler-spec-tests/pyproject.toml .
#extract "requirements" from "bundler-spec-test" project..
RUN perl -ne < pyproject.toml 'next unless /^dependencies/../^]/; next unless /"/; s/>=4.0.2/==4.0.2/; s/[" ,]//g; print ' > requirements.txt
RUN pip install -r requirements.txt && pip cache purge
