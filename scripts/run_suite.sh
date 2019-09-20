#!/usr/bin/env bash
set -e

CMD="robot --console verbose -i BelimoShowCase --outputdir /reports /suites"

echo ${CMD}

``${CMD}``
