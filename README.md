# PrintBone

A 3D printable trombone bell section. 8.5 inch, fits a Bach 42B.

Parameterized design that can easily be changed into any trombone bell profile.

Takes about 30 hours of print time on a Prusa i3 MK2.

# License
PrintBone is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License.

You are free to download and print your own trombones, for non commercial use only. If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

For commercial use, just send a message or e-mail.

# What is it based on?

This trombone is based on the model of a trombone with bessel curves published in the PhD thesis of Alistair C.P. Braden, Bore Optimisation and Impedance Modelling of Brass Musical Instruments, University of Edinburgh, 2006.
Of course, it does not implement the optimisation algorithm, but you use the output of such an algorithm and create a trombone with this script.
The parameters currently in place are the measurements he took. 
The thesis can be found at http://www.acoustics.ed.ac.uk/wp-content/uploads/Theses/Braden_Alistair__PhDThesis_UniversityOfEdinburgh_2006.pdf

# How does it look?

Photos will follow soon.

# How does it play?

Like a large bore trombone.

It sounds well and the partials are in tune. Mine still needs finishing, video will be posted later.

# Can I easily modify it to another model?

You certainly can!

# Usage

You can just download and print the STL files. To work with the OpenSCAD file:

Download and install the following libraries into the library folder of OpenSCAD:

https://github.com/openscad/scad-utils
https://github.com/openscad/list-comprehension-demos
http://www.thingiverse.com/thing:71464

Open bell.scad and set the part variable to "all" to render the entire trombone

You might want to edit tuning_slide.scad with a lower detail level, because it slows everything down.

#Known issues

It needs to be shortened a bit, because it does A=440 almost the tuning slide all the way in.



