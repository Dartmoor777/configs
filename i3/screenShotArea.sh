#!/usr/bin/env bash

# screenshots stuff

params="-frame "
base_folder="/tmp/"
file_path=${base_folder}$( date '+%Y-%m-%d_%H-%M-%S' )_screenshot.png
import ${params} ${file_path}
xclip -selection clipboard -target image/png -i < ${file_path}
