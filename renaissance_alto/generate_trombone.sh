#!/bin/bash
mkdir -p output
OpenSCAD -o output/bell_top.stl -Dpart=\"bell_top\" ./bell.scad &
OpenSCAD -o output/bell_middle.stl -Dpart=\"bell_middle\" ./bell.scad &
OpenSCAD -o output/bell_bottom.stl -Dpart=\"bell_bottom\" ./bell.scad &
OpenSCAD -o output/neckpipe.stl -Dpart=\"neckpipe\" ./bell.scad &
OpenSCAD -o output/tuning_slide.stl -Dpart=\"tuning_slide\" ./bell.scad &
