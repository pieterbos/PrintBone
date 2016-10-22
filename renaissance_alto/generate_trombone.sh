#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

openscad=$(type -P OpenSCAD || type -P openscad)

mkdir -p output

"$openscad" -o output/bell_top.stl -Dpart=\"bell_top\" ./bell.scad &
"$openscad" -o output/bell_middle.stl -Dpart=\"bell_middle\" ./bell.scad &
"$openscad" -o output/bell_bottom.stl -Dpart=\"bell_bottom\" ./bell.scad &
"$openscad" -o output/neckpipe.stl -Dpart=\"neckpipe\" ./bell.scad &
"$openscad" -o output/tuning_slide.stl -Dpart=\"tuning_slide\" ./bell.scad &
