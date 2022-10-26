FROM ubuntu:20.04

# Download the OctoML CLI.
# Install system dependencies.
# TODO: Remove unnecessary ones.
RUN apt-get update && apt-get upgrade -y && apt-get install curl -y

# RUN curl https://downloads.octoml.ai/octoml_ubuntu_v0.6.1.tar.gz -o octoml.tar.gz
# RUN tar -xf octoml.tar.gz

# FIXME: Debugging the pipeline. This binary below is v0.6.1, but waits 1 minute for the
# container to start instead of 60 seconds.
COPY octoml /octoml

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
