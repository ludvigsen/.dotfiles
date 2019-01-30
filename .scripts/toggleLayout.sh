#!/bin/bash
setxkbmap $KEYBOARD_LAYOUT; [[ $KEYBOARD_LAYOUT = "us" ]] && export KEYBOARD_LAYOUT=no || export KEYBOARD_LAYOUT=us
