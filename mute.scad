//CONSTANTS
pi = 3.14159265359;


//WALL THICKNESSES
//the wall thickness of the bell. For 8.5 inch, 1.6 works great. For tiny bells, 1.2 is enough.
bell_wall_thickness = 1.2;

/* [DETAIL PARAMETERS] */
//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 300;
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to a few hundred
steps=150;





/* [BELL PARAMETERS]*/
//the radius of the bell in mm
bell_radius = 108.60; 

bell_input = [
    ["BESSEL", 24, 49, 0.6, 108],

//    ["CONE", 47, 49, 8],

    ["BESSEL", 49, 20, -0.4, 40]
];

mute_bottom =  [];//[[20,0],  [5-1.2 + bell_wall_thickness, 0], [5-1.2 + bell_wall_thickness,-bell_wall_thickness/2], [4.7-1.2 + bell_wall_thickness, -4], [5-1.2 + bell_wall_thickness, -6], [5-1.2 + bell_wall_thickness,-40]];

//the thickness of the cork used, for visualization
render_cork = false;
cork_thickness = 1.6;


//the height of the tapered area that fits the bell. It's the outside shape only
tapered_area_height = 20;


//DO NOT RUN THIS SCRIPT, IT WILL GENERATE ERRORS!
//instead open one of the models in the sub-folders, for example large_tenor. This script will be called from there

use <bessel.scad>;

//the curve (not really a polygon, just a set of points for now!) of the bell
bell_profile2 = create_bell_profile(bell_input, steps);
bell_profile = concat(bell_profile2, mute_bottom);

/** it's possible to render a bell profile of a trombone to check the fit of the mute.
Don't try to make this trombone, it won't be great, but for reference this is good*/
render_bell_profile = false;
bell_polygon_thingy = [


    ["BESSEL", 15.07, 22.28, 0.894, 150.42],
    ["BESSEL", 22.28, 41.18, 0.494, 96.85],
    ["BESSEL", 41.18, 8.5*25.4/2, 1.110, 55.93]
];
bell_height = sum_length(bell_input, 0);

//bell_polygon_thingy = [["BESSEL", 10, 8.5*25.4/2, 0.8, 508]];
bell_profile_full = create_bell_profile(bell_polygon_thingy, 50);

cork_bessel = [
    ["BESSEL", bell_profile[0][0], bell_profile[0][0]+3.55, 0.6, tapered_area_height],
    ["CONE", bell_profile[0][0]+3.55, bell_radius_at_height(bell_profile, bell_height-tapered_area_height-2.2), 2.2]
];

cork_profile = create_bell_profile(cork_bessel, 50);

module cork_profile(thickness=bell_wall_thickness) {
    translate([0, -bell_height+sum_length(cork_bessel, 0)])
        //rotate_extrude()
        extrude_line(input_curve=cork_profile, wall_thickness=thickness, solid=true, remove_doubles=true, normal_walls=false);
}







render_bell_profile=true;

if(render_bell_profile) {
    %translate([0, 0, 39])
    rotate([-90,0,0])
//rotate([180,0,0])
//rotate_extrude()
    extrude_line(input_curve=bell_profile_full, wall_thickness=bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=true);
}

hole_diameter_top = 3.8;
hole_diameter_small=3.5;
hole_diameter_bottom = 4.6;
echo(bell_radius_at_height(bell_profile, bell_wall_thickness));
rotate([180,0,0]) {
  /*union() {
    //render_mute();
    translate([0,0,-bell_wall_thickness/2]){
      union() {
           difference() {
             cylinder(r2=20+bell_wall_thickness,
               r1=bell_radius_at_height(bell_profile, bell_wall_thickness*1)+bell_wall_thickness, 
               h=bell_wall_thickness, 
               center=true);
             cylinder(r=hole_diameter_bottom, h=bell_wall_thickness+0.4, center=true);
           }
       }
    }
    translate([0,0,-40])
       difference() {
        cylinder(h=40, r=hole_diameter_top+bell_wall_thickness*1.5);
            cylinder(h=34, r=hole_diameter_top);
            translate([0,0,34])
                cylinder(h=2, r1=hole_diameter_top, r2=hole_diameter_small);
            translate([0, 0, 36])
                   cylinder(h=4, r1=hole_diameter_small, r2=hole_diameter_bottom);
       }
   }*/
   


    rotate_extrude()
   union(){
        extrude_line(bell_profile, bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=false);
        muting_tube();
        //bottom
        mute_bottom();
        difference() {
            cork_profile();    
            solid_bell_profile();
        }
    }   

       render_cork = true;
   if(render_cork) {
        %rotate_extrude()
        difference() {
            cork_profile(bell_wall_thickness+cork_thickness);
        solid_bell_profile();
       }
   }

}

module mute_bottom(){
    radius_at_top_of_bottom = bell_radius_at_height(bell_profile, bell_wall_thickness)+bell_wall_thickness;
    polygon(points=[[hole_diameter_bottom,0], [20,0], [radius_at_top_of_bottom, -bell_wall_thickness], 
        [hole_diameter_bottom, -bell_wall_thickness]]);
}

module muting_tube() {
    tube_outside_radius = hole_diameter_top+bell_wall_thickness*1.5;
    polygon([
        //bottom edge of tube
        [hole_diameter_bottom, 0], [tube_outside_radius+bell_wall_thickness*2, 0], 
        [tube_outside_radius, -5], 
        //top edge of tube
        [tube_outside_radius, -40], [hole_diameter_top, -40],
        //and slightly smaller part near bottom
        [hole_diameter_top, -6], [hole_diameter_small, -2]
   ]);
}



module render_mute(profile_only=false) {
    
    polygon = bell_profile;//cut_curve(bell_profile, min_height, max_height);   

    if(!profile_only) {
        rotate_extrude()
        extrude_line(polygon, bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=false);
    } else {
       extrude_line(polygon, bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=false);
    }
}

module solid_bell() {
    rotate_extrude()   
    solid_bell_profile();
}

module solid_bell_profile() {
    extrude_line(bell_profile, bell_wall_thickness, solid=true, normall_walls=false);
}

function bell_radius_at_height(curve, height) =
        lookup(height, reverse_key_value(curve));
      /* [for (i = [1:1:len(curve)-1])
            if( curve[i-1][1] <= height && curve[i][1] >= height)
               curve[i][0]            
        ][0]
            ;*/
            
function reverse_key_value(array) = 
    [for (i = [1:1:len(array)-1])
        [-array[i][1], array[i][0]]
    ];
