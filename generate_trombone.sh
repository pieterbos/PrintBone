#!/bin/bash
mkdir -p output
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/bell_top.stl -Dpart=\"bell_top\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/bell_middle_1.stl -Dpart=\"bell_middle\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/bell_middle_2.stl -Dpart=\"bell_middle_2\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/bell_bottom_1.stl -Dpart=\"bell_bottom_1\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/bell_bottom_2.stl -Dpart=\"bell_bottom_2\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/neckpipe_bottom.stl -Dpart=\"neckpipe_bottom\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/neckpipe_top.stl -Dpart=\"neckpipe_top\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
# /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/tuning_slide.stl -Dpart=\"tuning_slide\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/connection_bottom.stl -Dpart=\"connection_bottom\" ~/Documents/OpenSCAD/bell/r4f/bell.scad & 
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o output/connection_top.stl -Dpart=\"connection_top\" ~/Documents/OpenSCAD/bell/r4f/bell.scad &
