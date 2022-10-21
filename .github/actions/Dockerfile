FROM ubuntu:20.04

# Download the OctoML CLI.
# Install system dependencies.
# TODO: Remove unnecessary ones.
RUN apt-get update && apt-get upgrade -y && apt-get install curl -y

RUN curl https://downloads.octoml.ai/octoml_ubuntu_v0.6.1.tar.gz -o octoml.tar.gz

RUN tar -xf octoml.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
