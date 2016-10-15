# PrintBone

A 3D printable trombone bell section. 8.5 inch, fits a Bach 42B.

Parameterized design that can easily be changed into any trombone bell profile.

Takes about 30 hours of print time on an original Prusa i3 MK2. It can most likely be printed faster with a 0.6mm or 0.8mm nozzle,

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

It still needs some finishing, but here it is, printed in silver PLA.

![Image of nearly finished PrintBone](http://i.imgur.com/ARro4TL.jpg)

# How does it play?

Like a large bore trombone.

It plays easily, sounds well and the partials are in tune. Mine still needs finishing, video will be posted later.

# Can I easily modify it to another model?

You certainly can! The design is mostly parameterized, so you can quite easily change things like the tuning slide diameters, neckpipe diameter, slide receiver and bell profile.

# Usage

You can just download and print the STL files. To work with the OpenSCAD file:

Download and install the following libraries into the library folder of OpenSCAD:

https://github.com/openscad/scad-utils
https://github.com/openscad/list-comprehension-demos
http://www.thingiverse.com/thing:71464

Open bell.scad and set the part variable to "all" to render the entire trombone

You might want to edit tuning_slide.scad with a lower detail level if you want to make changes, because it slows everything down.

The ```generate_trombone.sh``` script generates all the models in STL format, with many openscad instances running in parallel. It should take about 20-30 minutes at full detail.

# Instructions for building your own

1. generate the test parts for all connectors and adjust clearances if they do not fit (a howto will be written later)
1. Print the STL files or generate your own STL files and print those. layer height 0.2mm produces a very nice result, you can choose to do smaller layers for the braces and tuning slide if you want smoother results.
2. use sandpaper to get any edges of all the joints/connectors
3. Check for leaks. You can use soapy water to find them. Can be fixed with superglue or perhaps heat
4. Glue the joints together. Superglue works well if you print it in PLA.
5. check connectors for leaks and fix where needed

test play the trombone. The entire range should respond evenly at all volumes. If any notes are hard to play, you probably have a leak somewhere.

# How large a printer do I need?
The current model is meant to be printed on a printer that can print at least 21*22*20 centimeters. It can be modified for smaller or larger printers relatively easily.

If you want to print a smaller bell, a smaller printer will do.

# Known issues

- It needs to be shortened perhaps 5 millimeters, because it does A=442.5 with the tuning slide  all the way in.
- the connection between the braces and the bell are a bit hard to glue. should be replaced with the connectors on the other side pf the braces
- the bottom-most t-profile connector of the bell coulf use a bit of more clearance
- the brace most near the slide could be moved maybe half a centimeter towards the bell for more comfortable holding

# Slide

tips on how to obtain suitable tubes for a slide are welcome.
