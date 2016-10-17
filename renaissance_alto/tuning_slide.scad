//RENAISSANCE ALTO MODEL TUNING SLIDE

use <../bent_tubes.scad>
//76mm between center of tubes. That means length of
//76*pi/2 = 119.32mm

tuning_slide_length = 119.32;

tuning_slide_small_length=40;
tuning_slide_large_length=40;
tuning_slide_small_radius = 10.3/2;
tuning_slide_large_radius = 10.3/2;

tuning_bow_wall_thickness = 1.2;
tuning_slide_wall_thickness = 0.8;


$fn=300;
sweep_steps = 100;
tuning_slide_step_length_in_degrees = 1;



//the height of the mid-air raft that the slicer will add support to for stability
tuning_slide_support_height=0.2;
pi = 3.14159265359;
tuning_slide_radius = tuning_slide_length/pi;

//uncomment the following two lines to test just this file
//rotate([-90,0,0])
//tuning_slide();

module tuning_slide(solid = false) {
    union() {
        tuning_slide_no_support(solid);
        tuning_slide_support_small();
        tuning_slide_support_large();
    }
}

module tuning_slide_support_small() {
    difference() {
        translate([0, 0, -tuning_slide_radius-tuning_slide_small_radius*2+4]) {
            rotate([90,0,0]) {
                linear_extrude(height=tuning_slide_support_height) {
                    square([tuning_slide_small_radius, tuning_slide_small_radius*2], center=true);                        
                }
            }
        };
        tuning_slide_no_support(solid=true);
    }
}

module tuning_slide_support_large() {
    difference() {
        translate([0, 0, tuning_slide_radius+tuning_slide_large_radius*2-4]) {
            rotate([90,0,0]) {
                linear_extrude(height=tuning_slide_support_height) {
                    square([tuning_slide_small_radius, tuning_slide_small_radius*2], center=true);                        
                }
            }
        };
        tuning_slide_no_support(solid=true);
    }
}


module tuning_slide_no_support(solid=false) {
    
    tuning_slide_bow(solid);
    tuning_slide_small_sleeve(solid);
    tuning_slide_large_sleeve(solid);
    
}

module tuning_slide_bow(solid=false) {
    bent_tube(tuning_slide_length, tuning_slide_small_radius, tuning_slide_large_radius, 180, tuning_bow_wall_thickness, solid, sweep_steps, tuning_slide_step_length_in_degrees);
}


module tuning_slide_small_sleeve(solid=false) {
    translate([0, 0, -tuning_slide_radius]) { 
        rotate([90,0, 0]) {
            if(solid) {
                    cylinder(r=tuning_slide_small_radius+tuning_slide_wall_thickness, h=tuning_slide_small_length);
            } else {
                difference() {
                    cylinder(r=tuning_slide_small_radius+tuning_slide_wall_thickness, h=tuning_slide_small_length);
                    cylinder(r=tuning_slide_small_radius, h=tuning_slide_small_length);
                }
            }
        }
        
    };
}

module tuning_slide_large_sleeve(solid=false) {
     //large end of the tuning slide
    translate([0, 0, tuning_slide_radius]) {
        rotate([90,0, 0]) {
            if(solid) {
                  cylinder(r=tuning_slide_large_radius+tuning_slide_wall_thickness, h=tuning_slide_large_length);
            } else {
                difference() {
                    cylinder(r=tuning_slide_large_radius+tuning_slide_wall_thickness, h=tuning_slide_large_length);
                    cylinder(r=tuning_slide_large_radius, h=tuning_slide_large_length);
                }
            }
        }
    };
}

//tuning_slide(false);