use <scad-utils/transformations.scad>;
use <list-comprehension-demos/sweep.scad>;
use <array_iterator.scad>;

tuning_slide_length = 219.90;

tuning_slide_small_length=67.32;
tuning_slide_large_length=67.32;
tuning_slide_small_radius = 7.55;
tuning_slide_large_radius = 9.9;

tuning_bow_wall_thickness = 1.2;
tuning_slide_wall_thickness = 0.6;

tuning_slide_step_length_in_degrees = 1;

$fn=200;
sweep_steps = 200;

tuning_slide_scale_increase = (tuning_slide_large_radius/tuning_slide_small_radius)-1;

function circle_points (radius=1) = [ for (a=array_iterator(0,tuning_slide_step_length_in_degrees,360)) radius*[sin(a), cos(a)]];    
    
pi = 3.14159265359;


tuning_slide_radius = tuning_slide_length/pi;



function rotate_path(t) = [
    0,//tuning_slide_radius * cos(360 * t),
    tuning_slide_radius * sin(360 * t),
    -tuning_slide_radius * cos(360 * t)
];

function tuning_slide_transform(transform, scale_increase) = 
    [for (i=[0:1:len(transform)-1]) 
        transform[i] * scaling([1+scale_increase*i/len(transform),
        1+scale_increase*i/len(transform),
        1])//do not scale the length of the tuning slide
];


/*
    Small side insert that fixes a problem with the sweep() module
*/
module tuning_slide_small_insert() {
    translate([0, 0.2, -tuning_slide_radius]) {
        rotate([90,0,0]) {
            linear_extrude(height=0.45) {
                circle(tuning_slide_small_radius);                        
            }
        }
    };
}

/*
    large side insert that fixes a problem with the sweep() module
*/

module tuning_slide_large_insert() {
    translate([0, 0.1, tuning_slide_radius]) {
        rotate([90,0,0]) {
            linear_extrude(height=0.45) {
                circle(tuning_slide_large_radius);                        
            }
        }
    };
}

module tuning_slide(solid=false) {
    
    tuning_slide_bow(solid);
    tuning_slide_small_sleeve();
    tuning_slide_large_sleeve();
    
}

module tuning_slide_bow(solid=false) {
    step = 0.5/sweep_steps;
    path = [for (t=array_iterator(0, step, 0.5)) rotate_path(t)];
    path_transforms = construct_transform_path(path);

    if(!solid) {
        difference() {
            sweep(circle_points(tuning_slide_small_radius+ tuning_bow_wall_thickness), tuning_slide_transform(path_transforms, 0.3));
            sweep(circle_points(tuning_slide_small_radius), tuning_slide_transform(path_transforms, 0.3));
            //two inserts because the sweep leaves some polygons that should not be there
            //small end
            tuning_slide_small_insert();
            //and large end
            tuning_slide_large_insert();
        };
    } else {
        sweep(circle_points(tuning_slide_small_radius+ tuning_bow_wall_thickness), tuning_slide_transform(path_transforms, 0.3));
    }
}


module tuning_slide_small_sleeve() {
    translate([0, 0, -tuning_slide_radius]) { 
        rotate([90,0, 0]) {
            difference() {
                cylinder(r=tuning_slide_small_radius+tuning_slide_wall_thickness, h=tuning_slide_small_length);
                cylinder(r=tuning_slide_small_radius, h=tuning_slide_small_length);
            }
        }
    };
}

module tuning_slide_large_sleeve() {
     //large end of the tuning slide
    translate([0, 0, tuning_slide_radius]) {
        rotate([90,0, 0]) {
            difference() {
                cylinder(r=tuning_slide_large_radius+tuning_slide_wall_thickness, h=tuning_slide_large_length);
                cylinder(r=tuning_slide_large_radius, h=tuning_slide_large_length);
            }
        }
    };
}

//tuning_slide(false);