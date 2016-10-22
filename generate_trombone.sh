#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

openscad=$(type -P OpenSCAD || type -P openscad)

mkdir -p output

"$openscad" -o output/bell_top.stl -Dpart=\"bell_top\" ./bell.scad &
"$openscad" -o output/bell_middle_1.stl -Dpart=\"bell_middle\" ./bell.scad &
"$openscad" -o output/bell_middle_2.stl -Dpart=\"bell_middle_2\" ./bell.scad &
"$openscad" -o output/bell_bottom_1.stl -Dpart=\"bell_bottom_1\" ./bell.scad &
"$openscad" -o output/bell_bottom_2.stl -Dpart=\"bell_bottom_2\" ./bell.scad &
"$openscad" -o output/neckpipe_bottom.stl -Dpart=\"neckpipe_bottom\" ./bell.scad &
"$openscad" -o output/neckpipe_top.stl -Dpart=\"neckpipe_top\" ./bell.scad &
"$openscad" -o output/tuning_slide.stl -Dpart=\"tuning_slide\" ./bell.scad &
"$openscad" -o output/connection_bottom.stl -Dpart=\"connection_bottom\" ./bell.scad &
"$openscad" -o output/connection_top.stl -Dpart=\"connection_top\" ./bell.scad &
