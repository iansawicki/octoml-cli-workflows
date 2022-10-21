#!/bin/sh
OCTOML_AGREE_TO_TERMS=1
OCTOML_TELEMETRY=false

# TODO: Remove the package step and see if we can move it to a separate action.
./octoml package | ./octoml build | ./octoml deploy

# TODO: Run inference.
