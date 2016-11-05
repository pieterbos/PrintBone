/* Leadpipe that fits a jinbao alto. Plays ok - mine is more in tune than the original 
Print with the spiral vase option, then add tape to the top so it fits snug in the slide and the connection is airtight..
*/
$fn = 300;
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

inner_slide_tube_inner_radius=11.9/2;
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
leadpipe_length=199;
//the amount of space between leadpipe and inners
leadpipe_clearance=0; //since we don't print a slide, only a leadpipe, this is convenient
//the first part of the leadpipe is outside of the slide so the mouthpiece fits and 
//the leadpipe can be removed from the trombone slide
leadpipe_outside_slide_bit_length=50;
//which needs a wall thickness that can be a few mms
leadpipe_outside_slide_bit_wall_thickness=1.2;

//TODO: set these parameters to produce a good leadpipe!
leadpipe_venturi_radius=(10.7-0.8)/2;
leadpipe_venturi_distance_from_mouthpiece_receiver=15;
//do not change unless you have a very small nozzle that can print tiny very strong walls :)
leadpipe_end_radius=inner_slide_tube_inner_radius - leadpipe_clearance - 0.4;

/* [MOUTHPIECE RECEIVER] */
shank="small";
//mouthpiece_receiver_length = (shank == "small") ? 33 : 38;
//mouthpiece_receiver_small_radius = ((shank == "large") ? 6 : 5);
//according to bach guide: 13.867 and 12.6, 1 inch long
//mouthpiece_receiver_large_radius = ((shank == "large") ? 12.7 : 11)/2;

//this is according to bach mouthpiece guide, page 32. Might need extra clearance here too
mouthpiece_receiver_length = (shank == "large") ? 25.4 : 25.4*17/16;
mouthpiece_receiver_small_radius = ((shank == "large") ? 0.496*25.4 : 0.422*25.4)/2;
mouthpiece_receiver_large_radius = ((shank == "large") ? 0.546*25.4 : 0.475*25.4)/2;

echo((mouthpiece_receiver_large_radius+0.4)*2);
echo((mouthpiece_receiver_small_radius+0.4)*2);

union() {
    difference() {
        cylinder(r=mouthpiece_receiver_large_radius+2, h=3);
        cylinder(r=mouthpiece_receiver_large_radius, h=5);
    }
    difference() {
        mouthpiece_receiver(0.4);
        mouthpiece_receiver(0);
    }
    difference() {
        leadpipe_inner_shape(0.4);
        leadpipe_inner_shape(0);
    }
}

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


module leadpipe_inner_shape(tolerance=0) {
    //TODO: find out proper leadpipe shapes from actual leadpipes, or from research papers?
    translate([0,0,mouthpiece_receiver_length])
    cylinder(r1=mouthpiece_receiver_small_radius+tolerance, r2=leadpipe_venturi_radius+tolerance, h=leadpipe_venturi_distance_from_mouthpiece_receiver);
        translate([0,0,mouthpiece_receiver_length+leadpipe_venturi_distance_from_mouthpiece_receiver])
    cylinder(
        r1=leadpipe_venturi_radius+tolerance, 
        r2=leadpipe_end_radius+tolerance, 
        h= leadpipe_length-mouthpiece_receiver_length-leadpipe_venturi_distance_from_mouthpiece_receiver
    );
    
    
}

module mouthpiece_receiver(tolerance=0) {
    cylinder(r1=mouthpiece_receiver_large_radius+tolerance, 
        r2=mouthpiece_receiver_small_radius+tolerance,
        h=mouthpiece_receiver_length
    );
}

