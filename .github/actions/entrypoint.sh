#!/bin/sh
export OCTOML_AGREE_TO_TERMS=1
export OCTOML_TELEMETRY=false
export RUST_BACKTRACE=1
export RUST_LOG=info

# TODO: Remove the package step and see if we can move it to a separate action.
/octoml package | /octoml build | /octoml -v deploy
