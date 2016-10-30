/* Work in progress model of a slide. If you want to print this, be warned that this design is not finished - it has not been tested, the leadpipe quite a bit wrong and probably
parts do not assemble or otherwise fail
*/

use <bent_tubes.scad>;

slide_crook_tube_length=150;
slide_crook_radius=7.5;//15 mm diameter for now
slide_crook_wall_thickness=1.6;

pi = 3.14;//TODO
slide_crook_length=slide_crook_tube_length/pi;

sweep_steps=25;
circle_steps=1;

outer_slide_grip_radius=6.5;
inner_slide_grip_radius=outer_slide_grip_radius;

slide_tube_length=700;

//the distance between hand grip and end of inner slide

hand_grip_distance = 25;
oversleeve_length=75;

slide_crook_sleeve_length=50;


//these can be bought in carbon tubes.

inner_slide_tube_inner_radius=0.547*25.4/2;
inner_slide_tube_outer_radius=inner_slide_tube_inner_radius+0.5;
outer_slide_tube_inner_radius=inner_slide_tube_outer_radius+0.5;
outer_slide_tube_outer_radius=outer_slide_tube_inner_radius+0.5;


oversleeve_wall_thickness=2.0;
oversleeve_radius = outer_slide_tube_outer_radius + oversleeve_wall_thickness;


slide_grip_clearance = 1;
slide_grip_wall_thickness=1.6;

bell_connector_small_radius = 50/pi/2;
bell_connector_large_radius = 54.7/pi/2;
bell_connector_length = 31.5;


stockings_length=80;
stocking_wall_thickness=0.4;
stocking_clearance=0.1;

slide_crook_sleeve_radius=outer_slide_tube_outer_radius+2;

/* [LEAD PIPE] */
leadpipe_length=150;
//the amount of space between leadpipe and inners
leadpipe_clearance=0.12;
//the first part of the leadpipe is outside of the slide so the mouthpiece fits and 
//the leadpipe can be removed from the trombone slide
leadpipe_outside_slide_bit_length=28;
//which needs a wall thickness that can be a few mms
leadpipe_outside_slide_bit_wall_thickness=1.2;

//TODO: set these parameters to produce a good leadpipe!
leadpipe_venturi_radius=0.5*25.4/2;
leadpipe_venturi_distance_from_mouthpiece_receiver=15;
//do not change unless you have a very small nozzle that can print tiny very strong walls :)
leadpipe_end_radius=inner_slide_tube_inner_radius - leadpipe_clearance - 0.4;

/* [MOUTHPIECE RECEIVER] */
shank="large";
//mouthpiece_receiver_length = (shank == "small") ? 33 : 38;
//mouthpiece_receiver_small_radius = ((shank == "large") ? 6 : 5);
//according to bach guide: 13.867 and 12.6, 1 inch long
//mouthpiece_receiver_large_radius = ((shank == "large") ? 12.7 : 11)/2;

//this is according to bach mouthpiece guide, page 32. Might need extra clearance here too
mouthpiece_receiver_length = (shank == "large") ? 25.4 : 25.4*17/16;
mouthpiece_receiver_small_radius = ((shank == "large") ? 0.496*25.4 : 0.422*25.4)/2;
mouthpiece_receiver_large_radius = ((shank == "large") ? 0.546*25.4 : 0.475*25.4)/2;
#inner_slide_tubes();

#outer_slide_tubes();

slide_crook();

outer_slide_grip();

inner_slide_grip();

stockings();
$fn=100;
translate([20,0,0])
rotate([90, 0, 0])
union() {
    mouthpiece_receiver();
    leadpipe_inner_shape();
}

//translate([100,-slide_tube_length-leadpipe_outside_slide_bit_length-0, slide_crook_length])
//rotate([180,0,0])
leadpipe();

module leadpipe() {
    rotate([90, 0, 0])
    difference() {
        leadpipe_outer_shape();
        mouthpiece_receiver();
        leadpipe_inner_shape();
    }
}

module leadpipe_outer_shape() {
    union() {
        //part of tube outside of slide
        cylinder(r=mouthpiece_receiver_large_radius+leadpipe_outside_slide_bit_wall_thickness, h=leadpipe_outside_slide_bit_length);
        //part of tube inside slide
        translate([0,0,leadpipe_outside_slide_bit_length])
        cylinder(r=inner_slide_tube_inner_radius-leadpipe_clearance, h=leadpipe_length-leadpipe_outside_slide_bit_length);
    }
}


module leadpipe_inner_shape() {
    //TODO: find out proper leadpipe shapes from actual leadpipes, or from research papers?
    translate([0,0,mouthpiece_receiver_length])
    cylinder(r1=mouthpiece_receiver_small_radius, r2=leadpipe_venturi_radius, h=leadpipe_venturi_distance_from_mouthpiece_receiver);
    cylinder(
        r1=leadpipe_venturi_radius, 
        r2=leadpipe_end_radius, 
        h= leadpipe_length
    );
    
    
}

module mouthpiece_receiver() {
    cylinder(r1=mouthpiece_receiver_large_radius, 
        r2=mouthpiece_receiver_small_radius,
        h=mouthpiece_receiver_length
    );
}

module outer_slide_grip() {
    difference() {
        translate([0, -slide_tube_length + hand_grip_distance, -slide_crook_length])
        cylinder(r=outer_slide_grip_radius, h=slide_crook_length*2);
        outer_slide_tube_1();
        outer_slide_tube_2();
    };
    
    difference() {
        oversleeves(oversleeve_radius, oversleeve_length);
        outer_slide_tube_1();
        outer_slide_tube_2();
    }
}
module oversleeves(radius, length) {
    translate([0,-slide_tube_length+length,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=radius, h=length);

    translate([0,-slide_tube_length+length,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=radius, h=length);    
}


module slide_crook() {
    bent_tube(length=slide_crook_tube_length,
        radius1=slide_crook_radius, 
        radius2=slide_crook_radius,
        degrees=180,
        wall_thickness=slide_crook_wall_thickness,
        solid=false, 
        sweep_steps = sweep_steps, circle_steps=circle_steps);

    slide_crook_sleeve_1();
    slide_crook_sleeve_2();
}

module slide_crook_sleeve_1() {
    difference() {
        translate([0,0,slide_crook_length])
        rotate([90,0,0])
        cylinder(r=slide_crook_sleeve_radius, h=slide_crook_sleeve_length);
        outer_slide_tube_1();
    }
}


module slide_crook_sleeve_2() {
    difference() {
        translate([0,0,-slide_crook_length])
        rotate([90,0,0])
        cylinder(r=slide_crook_sleeve_radius, h=slide_crook_sleeve_length);
        outer_slide_tube_2();
    }
}
    
module outer_slide_tubes(extra_radius=0) {
  outer_slide_tube_1(extra_radius);
  outer_slide_tube_2(extra_radius);
}  

module inner_slide_tubes(extra_radius=0) {
  inner_slide_tube_1(extra_radius);
  inner_slide_tube_2(extra_radius);
}  

module outer_slide_tube_1(extra_radius=0) {
    translate([0,0,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=outer_slide_tube_outer_radius + extra_radius, h=slide_tube_length+2);
}

module outer_slide_tube_2(extra_radius=0) {
    translate([0,0,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=outer_slide_tube_outer_radius + extra_radius, h=slide_tube_length+2);
}


module inner_slide_tube_1(extra_radius=0) {
    translate([100,0,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=inner_slide_tube_outer_radius + extra_radius, h=slide_tube_length+2);
}

module inner_slide_tube_2(extra_radius=0) {
    translate([100,0,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=inner_slide_tube_outer_radius + extra_radius, h=slide_tube_length+2);
}

module inner_slide_grip() {
    // move a bit to the side so both inner and outer can be rendered at the same time

    union() {
        //1. the brace that you grip with your hand
        difference() {
            translate([100, -slide_tube_length + hand_grip_distance, -slide_crook_length])
            cylinder(r=outer_slide_grip_radius, h=slide_crook_length*2);
            translate([100,0,0])
            oversleeves(oversleeve_radius, 50);
        };
        
        //  2. The tubes in which the slide gets glued
        difference() {
            translate([100,0,0])
            oversleeves(oversleeve_radius, 50);
            inner_slide_tubes();
        }

        //  3. The tubes in which the slide goes when in first position        
        difference() {
            translate([100,0,0])
            oversleeves(outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness, oversleeve_length);
            translate([100,0,0])
            outer_slide_tubes(extra_radius=slide_grip_clearance);
        }
        translate([100,0,0])
        bell_connector();
    }
}



module bell_connector() {
    translate([0, -slide_tube_length, -slide_crook_length])
    rotate([90,0,0])
    difference() {
        cylinder(r1=bell_connector_large_radius, r2=bell_connector_small_radius, h= bell_connector_length);
        cylinder(r=inner_slide_tube_inner_radius, h=bell_connector_length);
    }
}

module stockings() {
    translate([100, 0, -slide_crook_length])
    stocking();
    translate([100, 0, slide_crook_length])
    stocking();
}

module stocking() {
    rotate([90,0,0])
    difference() {
        cylinder(r=inner_slide_tube_outer_radius + stocking_clearance + stocking_wall_thickness, h= stockings_length);
        inner_slide_tubes(stocking_clearance);
    }
}


    

