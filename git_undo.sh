#!/bin/bash

# undo all modifications to existing, tracked files in git.
#
# (will NOT undo add/rm/mv operations)
#
# useful as a quick rewind when doing small refactors.

git checkout -- $(
    git status --short |
    sed --quiet --expression '/^ M /{s/ M //p}' |
    xargs)
