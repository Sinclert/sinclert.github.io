#!/bin/sh

cd .. || exit
bundle exec htmlproofer ./_site
