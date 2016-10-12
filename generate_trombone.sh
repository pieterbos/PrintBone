#!/bin/bash
mkdir -p output
OpenSCAD -o output/bell_top.stl -Dpart=\"bell_top\" ./bell.scad &
OpenSCAD -o output/bell_middle_1.stl -Dpart=\"bell_middle\" ./bell.scad &
OpenSCAD -o output/bell_middle_2.stl -Dpart=\"bell_middle_2\" ./bell.scad &
OpenSCAD -o output/bell_bottom_1.stl -Dpart=\"bell_bottom_1\" ./bell.scad &
OpenSCAD -o output/bell_bottom_2.stl -Dpart=\"bell_bottom_2\" ./bell.scad &
OpenSCAD -o output/neckpipe_bottom.stl -Dpart=\"neckpipe_bottom\" ./bell.scad &
OpenSCAD -o output/neckpipe_top.stl -Dpart=\"neckpipe_top\" ./bell.scad &
OpenSCAD -o output/tuning_slide.stl -Dpart=\"tuning_slide\" ./bell.scad &
OpenSCAD -o output/connection_bottom.stl -Dpart=\"connection_bottom\" ./bell.scad & 
OpenSCAD -o output/connection_top.stl -Dpart=\"connection_top\" ./bell.scad &
