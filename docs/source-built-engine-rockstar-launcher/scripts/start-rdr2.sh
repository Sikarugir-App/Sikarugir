#!/bin/zsh
# Startet RDR2 im Sikarugir-Wrapper in zwei Phasen:
# 1. Launcher laeuft mit Wines eigenem Direct3D (D3DMetal kann kein D3D10.1)
# 2. Sobald der Launcher aktiv ist, wird D3DMetal eingelegt; das Spiel laedt es dann
A=~/Applications/Sikarugir/Untitled.app; S=$A/Contents/SharedSupport; R=$S/renderer/d3dmetal; O=$HOME/cx-build/out/lib/wine; W=$S/wine/lib/wine
LOG=~/Documents/"Rockstar Games/Launcher/launcher.log"
pkill -f winetemp; pkill -f wineserver; pkill -f "MacOS/launcher"; sleep 3
# Phase 1: nur Eigenbau-Dateien (D3DMetal-Reste entfernen)
for d in x86_64-unix x86_64-windows; do for f in $(ls "$R/wine/$d"); do
  if [ -e "$O/$d/$f" ]; then cp -p "$O/$d/$f" "$W/$d/$f"; else rm -f "${W:?}/${d:?}/${f:?}"; fi
done; done
rm -rf "${S:?}/wine/lib/external"
plutil -replace "Program Name and Path" -string "/Program Files/Rockstar Games/Red Dead Redemption 2/RDR2.exe" $A/Contents/Info.plist
touch /tmp/rdr2.start; sleep 1; START=$(date +%s)
open $A
for i in $(seq 1 90); do sleep 2; [ "$LOG" -nt /tmp/rdr2.start ] && grep -q "WaitForWindow -> Active" "$LOG" && break; done
echo "Launcher aktiv nach $(( $(date +%s) - START ))s"
# Phase 2: D3DMetal einlegen (rm + cp: der laufende Launcher behaelt seine alten Dateien)
for d in x86_64-unix x86_64-windows; do for f in $(ls "$R/wine/$d"); do rm -f "${W:?}/${d:?}/${f:?}"; cp -p "$R/wine/$d/$f" "$W/$d/$f"; done; done
mkdir -p "$S/wine/lib/external" && cp -R "$R/external/." "$S/wine/lib/external/"
echo "D3DMetal eingelegt nach $(( $(date +%s) - START ))s"
