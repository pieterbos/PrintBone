/* Leadpipe that fits a jinbao alto. Plays ok - mine is more in tune than the original 
Print with the spiral vase option, then add tape to the top so it fits snug in the slide and the connection is airtight..
*/
$fn = 200;

/* [LEAD PIPE] */
//radius of the inner slide tubes
inner_slide_tube_inner_radius=11.9/2;
//length of the leadpipe
leadpipe_length=199;
//the amount of space between leadpipe and inners
leadpipe_clearance=0; //since we don't print a slide, only a leadpipe, this is convenient
//the first part of the leadpipe is outside of the slide so the mouthpiece fits and 
//the leadpipe can be removed from the trombone slide
leadpipe_outside_slide_bit_length=5;
//which needs a wall thickness that can be a few mms
leadpipe_outside_slide_bit_wall_thickness=2;

leadpipe_wall_thickness=0.4;

//TODO: set these parameters to produce a good leadpipe!
leadpipe_venturi_radius=(10.7-0.8)/2;
leadpipe_venturi_distance_from_mouthpiece_receiver=15;
//do not change unless you have a very small nozzle that can print tiny very strong walls :)
leadpipe_end_radius=inner_slide_tube_inner_radius - leadpipe_clearance - leadpipe_wall_thickness;

/* [MOUTHPIECE RECEIVER] */
shank="small";

large_shank_large_end_diameter = 0.546*25.4;
large_shank_small_end_diameter = 0.496*25.4;
large_shank_length = 25.4;

small_shank_large_end_diameter = 0.475*25.4;
small_shank_small_end_diameter = 0.422*25.4;
small_shank_length = 25.4*17/16;

//this is according to bach mouthpiece guide, page 32. Might need extra clearance here too
mouthpiece_receiver_length = (shank == "large") ? large_shank_length : small_shank_length;

mouthpiece_receiver_small_radius = ((shank == "large") ? large_shank_small_end_diameter : small_shank_small_end_diameter)/2;
mouthpiece_receiver_large_radius = ((shank == "large") ? large_shank_large_end_diameter : small_shank_large_end_diameter)/2;

union() {
    //the mouthpiece receiver
    difference() {
        union() {
            //outside shape
            mouthpiece_receiver(leadpipe_wall_thickness);
            //the extra wide bit that sticks out of the slide.
            cylinder(r=mouthpiece_receiver_large_radius+leadpipe_outside_slide_bit_wall_thickness, h=leadpipe_outside_slide_bit_length);
        }
        //inside
        mouthpiece_receiver(0);
    }
    //the rest of the leadpipe
    difference() {
        //outside
        leadpipe_inner_shape(leadpipe_wall_thickness);
        //inside
        leadpipe_inner_shape(0);
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

