#!/usr/bin/env bash

# Configuration
osd='no'
inc='2'
capvol='no'
maxvol='200'
autosync='yes'

# Default variables
curStatus="no"
active_sink=""
limit=$((100 - inc))
maxlimit=$((maxvol - inc))

reloadSink() {
  #active_sink=$(pactl list short sinks | awk '{print $1}' | head -n 1)
  active_sink="46"
}

function volUp {
  getCurVol

  if [ "$capvol" = 'yes' ]; then
    if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]; then
      pactl set-sink-volume "$active_sink" 100%
    elif [ "$curVol" -lt "$limit" ]; then
      pactl set-sink-volume "$active_sink" "+$inc%"
    fi
  elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]; then
    pactl set-sink-volume "$active_sink" "$maxvol%"
  elif [ "$curVol" -lt "$maxlimit" ]; then
    pactl set-sink-volume "$active_sink" "+$inc%"
  fi

  getCurVol

  if [ ${osd} = 'yes' ]; then
    qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
  fi

  if [ ${autosync} = 'yes' ]; then
    volSync
  fi
}

function volDown {
  pactl set-sink-volume "$active_sink" "-$inc%"
  getCurVol

  if [ ${osd} = 'yes' ]; then
    qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
  fi

  if [ ${autosync} = 'yes' ]; then
    volSync
  fi
}

function getSinkInputs {
  input_array=$(pactl list short sink-inputs | awk '{print $1}')
}

function volSync {
  getSinkInputs
  getCurVol

  for each in $input_array; do
    pactl set-sink-input-volume "$each" "$curVol%"
  done
}

function getCurVol {
  curVol=$(pactl get-sink-volume "$active_sink" | grep -o '[0-9]*%' | head -n 1 | tr -d '%')
}

function volMute {
  case "$1" in
  mute)
    pactl set-sink-mute "$active_sink" 1
    curVol=0
    status=1
    ;;
  unmute)
    pactl set-sink-mute "$active_sink" 0
    getCurVol
    status=0
    ;;
  esac

  if [ ${osd} = 'yes' ]; then
    qdbus org.kde.kded /modules/kosd showVolume ${curVol} ${status}
  fi
}

function volMuteStatus {
  curStatus=$(pactl get-sink-mute "$active_sink" | awk '{print $2}')
}

function listen {
  firstrun=0

  pactl subscribe 2>/dev/null | {
    while true; do
      {
        if [ $firstrun -eq 0 ]; then
          firstrun=1
        else
          read -r event || break
          if ! echo "$event" | grep -e "on card" -e "on sink"; then
            continue
          fi
        fi
      } &>/dev/null
      output
    done
  }
}

function output() {
  reloadSink
  getCurVol
  volMuteStatus
  if [ "${curStatus}" = 'yes' ]; then
    echo "ﱝ mute"
  else
    echo "$curVol%"
  fi
}

reloadSink
case "$1" in
--up)
  volUp
  ;;
--down)
  volDown
  ;;
--togmute)
  volMuteStatus
  if [ "$curStatus" = 'yes' ]; then
    volMute unmute
  else
    volMute mute
  fi
  ;;
--mute)
  volMute mute
  ;;
--unmute)
  volMute unmute
  ;;
--sync)
  volSync
  ;;
--listen)
  listen
  ;;
*)
  output
  ;;
esac
