# PrintBone

A 3D printable trombone generator. You can use it to generate printable models for any trombone you like.

Currently included finished trombone designs:
- A large bore, 8.5 inch trombone. The bell fits a Bach 42 or 50 slide, or the included PVC slide.
- A small bore, 7 inch trombone. The bell fits a Conn 48h/6H or director slide, or the included carbon fiber slide

The design is fully parameterized. This means you can use the scripts to create any trombone design you want, with any bell profile. This included modern trombone bore shapes, but is flexible enough to also create baroque models

The bell takes about 15-30 hours of print time. It can most likely be printed faster with a 0.6mm or 0.8mm nozzle.
The slide takes about 8-12 hours print time.

# Current state

The large tenor and the small tenor both work well and play well enough to be used as a serious musical instrument.

A baroque trombone and alto design have been added. The designs both have some rather serious playability issues.

The master branch or at least commit a49e66a41785ac1fe58c5a61df087de6b6ca1ddf contain a fully working version. The large tenor is ready to print and small tenor could use some fixes:

Open issues before release:
- the small tenor is slightly too short, that should be easy to fix.
- Tuning on some partials on small the tenor are acceptable, but could be better.
- Still requires 200mm of print area height for the small tenor - perhaps I should cut it up differently so it can print on popular printers with 180mm height?

Wishlist:
- more designs, including some historical trombones
- a way to construct a good inner slide
- a 7 or 7.5 inch bell that prints without supports - should be very possible, looking at some existing designs

# License
PrintBone is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License.

You are free to download and print your own trombones, for non commercial use only. If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

For commercial use, just send a message or e-mail.

# What is it based on?

This trombone is based on the model of a trombone with bessel curves published in the PhD thesis of Alistair C.P. Braden, Bore Optimisation and Impedance Modelling of Brass Musical Instruments, University of Edinburgh, 2006.
Of course, it does not implement the optimisation algorithm, but you can use the output of such an algorithm and create a trombone with this script.
The parameters currently in place are the measurements he took. 
The thesis can be found at http://www.acoustics.ed.ac.uk/wp-content/uploads/Theses/Braden_Alistair__PhDThesis_UniversityOfEdinburgh_2006.pdf

The leadpipe design is inspired by a Conn 88H leadpipe, but not a reproduction.

# How does it look?

In silver and blue with PVC tubes slide:

![Image of nearly PrintBone](http://i.imgur.com/crLUNry.jpg)

# How does it play?

Like a  trombone.

It plays easily, sounds well and the partials are in tune. A short recording of both a printed bell and a regular brass bell with a metal slide is at https://soundcloud.com/pieter-bos-2013025 - can you guess which one is which?
Also on soundcloud is a work-in-progress recording of the bell with a PVC slide. Expect improvements later on as I fix some leaks in the slide.

# Can I easily modify it to another model?

You certainly can!

1. Download this code
2. Download the dependencies
3. Copy the large_tenor folder to a different one, give it a nice name
4. Edit the parameters of the .scad file according to the documentation in the file.

# Dependencies

Check the download_dependencies.sh script, it will download the list-comprehension demos, the curved pipe library and scad-utils. Run this in the library folder of your OpenSCAD installation for this to work in all cases. Alternatively, work with a release version that contains all the dependencies plus the code in one archive file.

# Usage

You can just download and print the STL files. To work with the OpenSCAD file:

Download and install the following libraries into the library folder of OpenSCAD:

https://github.com/openscad/scad-utils
https://github.com/openscad/list-comprehension-demos
http://www.thingiverse.com/thing:71464

Open large_tenor/large_tenor.scad and set the part variable to "all" to render the entire trombone.
the variables you can set are documented in that scad file.

The ```generate_trombone.sh``` script generates all the models in STL format, with many openscad instances running in parallel. It should take about 20-30 minutes at full detail.

# Instructions for building your own bell.

1. generate the test parts for all connectors and adjust clearances if they do not fit (a howto will be written later)
1. Print the STL files or generate your own STL files and print those. layer height 0.2mm produces a very nice result, you can choose to do smaller layers for the braces and tuning slide if you want smoother results.
2. use sandpaper to get any edges of all the joints/connectors
3. Check for leaks. You can use soapy water to find them. Can be fixed with superglue or perhaps heat
4. Glue the joints together. Superglue works well if you print it in PLA.
5. check connectors for leaks and fix where needed

test play the trombone. The entire range should respond evenly at all volumes. If any notes are hard to play, you probably have a leak somewhere.

# How large a printer do I need?
The current large bore model is meant to be printed on a printer that can print at least 21*22*20 centimeters. The small bore model fits on 180x180x200mm printers. It can be modified for smaller or larger printers relatively easily.

# Slide

A full PVC slide with printed parts has been made, including stockings. It works, but does not sound great, especially at lower volumes. Lubricate with slide cream, slide-o-mix or yamaha does not work well.

http://imgur.com/a/jYNtB

Also a Carbon fiber slide has been made. The design has been modified so it prints without supports. The carbon fiber slide is playable and a lot better than the pvc slide, but not great yet. To fix, a different material for the stockings is needed.
The carbon fiber outer slide also fits a Bach 42B inner slide, and works very well on that. The exceptionally light slide really makes for a different playing experience! It could be improved by finding a 14.9mm carbon fiber tube instead of 15mm one so it leaks less air.

To play with the slide design, check slide.scad and the stl files in the slide_out/ directory.
