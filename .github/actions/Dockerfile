FROM ubuntu:20.04

# Download the OctoML CLI.
RUN wget https://downloads.octoml.ai/octoml_ubuntu_v0.6.1.tar.gz && tar -xf octoml_ubuntu_v0.6.1.tar.gz

# Install system dependencies.
# TODO: Remove unnecessary ones.
RUN apt update && apt-upgrade -y && apt install python3.8 libgl1-mesa-glx libglib2.0-0 -y

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
