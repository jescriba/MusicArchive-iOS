#!/bin/bash

brew update
export HOMEBREW_NO_AUTO_UPDATE=1

for dep in "$@"; do
  if brew ls --versions "$dep" >/dev/null; then
    brew outdated "$dep" || brew upgrade "$dep"
  else
    brew install "$dep"
  fi
done
