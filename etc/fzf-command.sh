#!/bin/bash
mapfile IN
notify-send "$0" "$#:$*:IN=${IN}"
