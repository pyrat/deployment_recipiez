#!/bin/zsh

rm *.gem
gem build recipiez.gemspec
gem push `ls *.gem`