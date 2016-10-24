#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

openscad=$(type -P OpenSCAD || type -P openscad)

mkdir -p output

# This script starts openSCAD in the background many times, because it's the only way to do multithreaded rendering
"$openscad" -o output/bell_top.stl -Dpart=\"bell_top\" ./large_tenor.scad &
"$openscad" -o output/bell_middle_1.stl -Dpart=\"bell_middle\" ./large_tenor.scad &
#uncomment if you set render_bell_flare_in_two_pieces to true
#"$openscad" -o output/bell_bottom_top_part.stl -Dpart=\"bell_bottom_top_part\" ./large_tenor.scad &
"$openscad" -o output/bell_bottom_1.stl -Dpart=\"bell_bottom_1\" ./large_tenor.scad &
"$openscad" -o output/bell_bottom.stl -Dpart=\"bell_bottom\" ./large_tenor.scad &
"$openscad" -o output/neckpipe_bottom.stl -Dpart=\"neckpipe_bottom\" ./large_tenor.scad &
"$openscad" -o output/neckpipe_top.stl -Dpart=\"neckpipe_top\" ./large_tenor.scad &
"$openscad" -o output/tuning_slide.stl -Dpart=\"tuning_slide\" ./large_tenor.scad &
#"$openscad" -o output/connection_bottom.stl -Dpart=\"connection_bottom\" ./large_tenor.scad & 
#"$openscad" -o output/connection_top.stl -Dpart=\"connection_top\" ./large_tenor.scad &
