#! /bin/bash

# assumes *nix program avconv is installed

for f in *.mp3; do avconv -i "$f" "${f/%mp3/wav}"; done

