#!/bin/sh

day=$1

# run swift tests matching the day
swift test -c release --filter "AdventOfCode2022Tests.Day($day)"
