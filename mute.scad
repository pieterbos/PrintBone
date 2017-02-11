use <bessel.scad>;

//CONSTANTS
pi = 3.14159265359;

//WALL THICKNESSES
//the wall thickness of the bell. For 8.5 inch, 1.6 works great. For tiny bells, 1.2 is enough.
bell_wall_thickness = 1.2;

/* [DETAIL PARAMETERS] */
//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 300;
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to 100-150
steps=150;


/* [BELL PARAMETERS]*/
//the mute, as a series of bessel curves
mute_input = [
    ["BESSEL", 24, 49, 0.6, 108],
    ["BESSEL", 49, 20, -0.4, 40]
];

//the thickness of the cork used, for visualization
render_cork = false;
cork_thickness = 1.6;

//the height of the tapered area that fits the bell. It's the outside shape only
tapered_area_height = 20;

//the curve (not yet a polygon, just a set of points on a line for now!) of the mute
bell_profile = create_bell_profile(mute_input, steps);

//it's possible to render a bell profile of a trombone to check the fit of the mute.
// This is the printbone, but you can render any trombone you want of course
render_bell_profile = true;

//the diameters of the tube used to mute
hole_diameter_top = 3.8;
//and the smallest part
hole_diameter_small=3.5;
//and the largest part at the bottom of the mute
hole_diameter_bottom = 4.6;

bell_input = [
//the printbone
    ["BESSEL", 15.07, 22.28, 0.894, 150.42],
    ["BESSEL", 22.28, 41.18, 0.494, 96.85],
    ["BESSEL", 41.18, 8.5*25.4/2, 1.110, 55.93]
];
bell_height = sum_length(mute_input, 0);
bell_profile_full = create_bell_profile(bell_input, 50);
echo(bell_profile);
echo(bell_radius_at_height(bell_profile, bell_height-tapered_area_height-2.2));
cork_bessel = [
    ["BESSEL", bell_profile[0][0], bell_profile[0][0]+3.55, 0.6, tapered_area_height],
    ["CONE", bell_profile[0][0]+3.55, bell_radius_at_height(bell_profile, bell_height-tapered_area_height-2.2), 2.2]
];

cork_profile = create_bell_profile(cork_bessel, 50);

render_bell_profile=false;

if(render_bell_profile) {
    translate([0, 0, 39])
rotate([90,0,0])
//rotate_extrude()
    extrude_line(input_curve=bell_profile_full, wall_thickness=bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=true);
}

rotate_extrude()
union(){
    extrude_line(bell_profile, bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=false);
    muting_tube();
    //bottom
    mute_bottom();
    difference() {
        cork_profile();    
        solid_mute_profile();
    }
}   

//render the cork to test fit
if(render_cork) {
    %rotate_extrude()
    difference() {
        cork_profile(bell_wall_thickness+cork_thickness);
    solid_mute_profile();
   }
}



module mute_bottom(){
    radius_at_top_of_bottom = bell_radius_at_height(bell_profile, bell_wall_thickness)+bell_wall_thickness;
    polygon(points=[[hole_diameter_bottom,0], [20,0], [radius_at_top_of_bottom, bell_wall_thickness], 
        [hole_diameter_bottom, bell_wall_thickness]]);
}

module muting_tube() {
    tube_outside_radius = hole_diameter_top+bell_wall_thickness*1.5;
    polygon([
        //bottom edge of tube
        [hole_diameter_bottom, 0], [tube_outside_radius+bell_wall_thickness*2, 0], 
        [tube_outside_radius, 5], 
        //top edge of tube
        [tube_outside_radius, 40], [hole_diameter_top, 40],
        //and slightly smaller part near bottom
        [hole_diameter_top, 6], [hole_diameter_small, 2]
   ]);
}

module cork_profile(thickness=bell_wall_thickness) {
    translate([0, bell_height-sum_length(cork_bessel, 0)])
        //rotate_extrude()
        extrude_line(input_curve=cork_profile, wall_thickness=thickness, solid=true, remove_doubles=true, normal_walls=false);
}

module solid_mute_profile() {
    extrude_line(bell_profile, bell_wall_thickness, solid=true, normall_walls=false);
}

function bell_radius_at_height(curve, height) =
    radius_at_height( curve, height);