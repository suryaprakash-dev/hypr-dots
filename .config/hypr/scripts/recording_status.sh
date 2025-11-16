#!/bin/env bash

if pgrep -x "wf-recorder" > /dev/null; then
  echo '{"text": " REC ", "tooltip": "Recording active", "class": "recording-active"}'
else
  echo '{"text": "", "tooltip": "", "class": "recording-inactive"}'
fi
