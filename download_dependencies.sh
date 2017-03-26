#!/usr/bin/bash
# download dependencies
if [ ! -e scad-utils ]; then
    git clone https://github.com/openscad/scad-utils.git
fi
if [ ! -e list-comprehension-demos ]; then
    git clone https://github.com/openscad/list-comprehension-demos.git
fi
if [ ! -e Curved_Pipe_Library_for_OpenSCAD/curvedPipe.scad ]; then
    mkdir -p Curved_Pipe_Library_for_OpenSCAD
    wget -O Curved_Pipe_Library_for_OpenSCAD/curvedPipe.scad \
        http://www.thingiverse.com/download:170713
    wget -O Curved_Pipe_Library_for_OpenSCAD/moreShapes.scad \
        http://www.thingiverse.com/download:170714
    wget -O Curved_Pipe_Library_for_OpenSCAD/vector.scad \
        http://www.thingiverse.com/download:170715
    wget -O Curved_Pipe_Library_for_OpenSCAD/maths.scad \
        http://www.thingiverse.com/download:170716
fi
