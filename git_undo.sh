#!/bin/bash

git checkout -- $(
    git status --short |
    sed --quiet --expression '/^ M /{s/ M //p}' |
    xargs)
