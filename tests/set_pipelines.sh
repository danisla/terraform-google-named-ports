#!/usr/bin/env bash

fly -t tf set-pipeline -p tf-named-ports-regression -c tests/pipelines/tf-named-ports-regression.yaml -l tests/pipelines/values.yaml

fly -t tf expose-pipeline -p tf-named-ports-regression