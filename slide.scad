/* Work in progress model of a slide. If you want to print this, be warned that this design is not finished - it has not been tested, the leadpipe quite a bit wrong and probably
parts do not assemble or otherwise fail
*/

use <bent_tubes.scad>;

$fn=300;

slide_crook_tube_length=150;
slide_crook_radius=7.5;//15 mm diameter for now
slide_crook_wall_thickness=3.6;

pi = 3.14;//TODO
slide_crook_length=slide_crook_tube_length/pi;

sweep_steps=100;
circle_steps=1;

slide_tube_length=700;  

//the distance between hand grip and end of inner slide

hand_grip_distance = 18;
oversleeve_length=75;

slide_crook_sleeve_length=50;


//these can be bought in carbon tubes.

inner_slide_tube_inner_radius=13.7/2;
inner_slide_tube_outer_radius=16.1/2;//(25.4*(5/8))/2;
outer_slide_tube_inner_radius=16.7/2;
outer_slide_tube_outer_radius=(25.4*(3/4))/2;

outer_slide_grip_radius=6.5;

oversleeve_wall_thickness=0;

oversleeve_radius = outer_slide_tube_outer_radius + oversleeve_wall_thickness;

outer_oversleeve_wall_thickness = 1.2;

outer_oversleeve_radius = outer_slide_tube_outer_radius + outer_oversleeve_wall_thickness;

slide_grip_inner_slide_clearance=0.08;
slide_grip_clearance = 1.2;
slide_grip_wall_thickness=1.6;

bell_connector_small_radius = 50/pi/2;
bell_connector_large_radius = 54.7/pi/2;
bell_connector_length = 31.5;


stockings_length=90;
stocking_wall_thickness=0.37;
stocking_clearance=0.05;

slide_crook_sleeve_radius=outer_slide_tube_outer_radius+2;

/* [MOUTHPIECE RECEIVER] */
shank="large";
//mouthpiece_receiver_length = (shank == "small") ? 33 : 38;
//mouthpiece_receiver_small_radius = ((shank == "large") ? 6 : 5);
//according to bach guide: 13.867 and 12.6, 1 inch long
//mouthpiece_receiver_large_radius = ((shank == "large") ? 12.7 : 11)/2;

//this is according to bach mouthpiece guide, page 32. Will need extra clearance here too
mouthpiece_receiver_clearance = 0.1;
mouthpiece_receiver_length = (shank == "large") ? 25.4 : 25.4*17/16;
mouthpiece_receiver_small_radius = mouthpiece_receiver_clearance + ((shank == "large") ? 0.496*25.4 : 0.422*25.4)/2;
mouthpiece_receiver_large_radius = mouthpiece_receiver_clearance + ((shank == "large") ? 0.546*25.4 : 0.475*25.4)/2;
/*
#inner_slide_tub

/* [LEAD PIPE] */
leadpipe_length=199.8;
//the amount of space between leadpipe and inners
leadpipe_clearance=0.05;
//the first part of the leadpipe is outside of the slide so the mouthpiece fits and 
//the leadpipe can be removed from the trombone slide
leadpipe_outside_slide_bit_length=4;
//which needs a wall thickness
leadpipe_outside_slide_bit_wall_thickness=1.2;



//TODO: set these parameters to produce a good leadpipe!
leadpipe_venturi_radius=12/2;
leadpipe_venturi_distance_from_mouthpiece_receiver=70-mouthpiece_receiver_length;
//do not change unless you have a very small nozzle that can print tiny very strong walls :)
leadpipe_end_radius=inner_slide_tube_inner_radius - leadpipe_clearance - 0.4;

echo(leadpipe_venturi_radius);
echo(leadpipe_end_radius);

/*#inner_slide_tubes();
#outer_slide_tubes();

slide_crook();

outer_slide_grip();



stockings();
$fn=100;
translate([20,0,0])
rotate([90, 0, 0])
union() {
    mouthpiece_receiver();
    leadpipe_inner_shape();
}*/

//intersection() {
//inner_slide_grip();
//outer_slide_grip();
//slide_crook();
//translate([100,0,0])
//    top_oversleeve(13, 100, solid=true);
//}//*/
stocking();
//leadpipe();
/* renders a leadpipe with the set parameters, that can have extra_radius.
it can be solid or not and it can have a bit of extra length at the outside
 */
module leadpipe(extra_radius=0, solid=false, extra_outside_length=0) {
    translate([100,-slide_tube_length-0, slide_crook_length])
    rotate([180,0,0])
    rotate([90, 0, 0])
    union() {
        difference() {
            leadpipe_inner_shape(extra_radius+0.4);
            if(!solid) {
                leadpipe_inner_shape(extra_radius+0);
            }
        }
        difference() {
            leadpipe_outer_bit(extra_radius, extra_outside_length);
            mouthpiece_receiver(extra_radius);
            if(!solid) {
                leadpipe_inner_shape();
            }
        }
    }
}

module leadpipe_outer_bit(extra_radius=0, extra_outside_length=0) {
    union() {
        //part of tube outside of slide
        cylinder(r=mouthpiece_receiver_large_radius + extra_radius + leadpipe_outside_slide_bit_wall_thickness, h=leadpipe_outside_slide_bit_length);
        if(extra_outside_length > 0) {
            translate([0,0,-extra_outside_length])
            cylinder(r=mouthpiece_receiver_large_radius + extra_radius + leadpipe_outside_slide_bit_wall_thickness, h=extra_outside_length);
        }
        //part of tube inside slide
    //    translate([0,0,leadpipe_outside_slide_bit_length])
     //   cylinder(r=inner_slide_tube_inner_radius-leadpipe_clearance, h=leadpipe_length-leadpipe_outside_slide_bit_length);
    }
}


module leadpipe_inner_shape(extra_radius=0) {
    
    cylinder(
        r1=mouthpiece_receiver_large_radius+extra_radius, 
        r2=mouthpiece_receiver_small_radius+extra_radius, 
        h=mouthpiece_receiver_length);
    
    translate([0,0,mouthpiece_receiver_length])
    cylinder(r1=mouthpiece_receiver_small_radius+extra_radius, r2=leadpipe_venturi_radius+extra_radius, h=leadpipe_venturi_distance_from_mouthpiece_receiver);
    translate([0,0,mouthpiece_receiver_length+leadpipe_venturi_distance_from_mouthpiece_receiver])
    cylinder(
        r1=leadpipe_venturi_radius + extra_radius, 
        r2=leadpipe_end_radius + extra_radius, 
        h= leadpipe_length-mouthpiece_receiver_length-leadpipe_venturi_distance_from_mouthpiece_receiver
    );
    
    
}

module mouthpiece_receiver(extra_radius=0) {
    cylinder(r1=mouthpiece_receiver_large_radius+extra_radius, 
        r2=mouthpiece_receiver_small_radius+extra_radius,
        h=mouthpiece_receiver_length
    );
}

module outer_slide_grip() {
    difference() {
        translate([0, -slide_tube_length + hand_grip_distance, -slide_crook_length])
        cylinder(r=outer_slide_grip_radius, h=slide_crook_length*2);
        oversleeves(outer_oversleeve_radius, oversleeve_length);
    };
    
    difference() {
        oversleeves(outer_oversleeve_radius, oversleeve_length);
        outer_slide_tubes(slide_grip_inner_slide_clearance, true);
    }
}

module oversleeves(radius, length, start_position=0) {
    top_oversleeve(radius, length, start_position);
    bottom_oversleeve(radius, length, start_position);
}
module top_oversleeve(radius, length, start_position=0) {
    translate([0,-slide_tube_length+length+start_position,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=radius, h=length);
}

module bottom_oversleeve(radius, length, start_position=0) { 
    translate([0,-slide_tube_length+length+start_position,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=radius, h=length);    
}


module slide_crook() {
    difference() {
        union() {
            difference() {
                slide_bow(solid=false);
                translate([-100,0.1,-0])
                inner_slide_tubes(solid=true);
            }
            slide_crook_sleeve(slide_crook_length);
            slide_crook_sleeve(-slide_crook_length);
        }

    }
    
}

module slide_bow(solid=false) {
    bent_tube(length=slide_crook_tube_length,
        radius1=slide_crook_radius,
        radius2=slide_crook_radius,
        degrees=180,
        wall_thickness=slide_crook_wall_thickness,
        solid=solid, 
        sweep_steps = sweep_steps, circle_steps=circle_steps);
}

module slide_crook_sleeve(translate) {
    difference() {
        translate([0,0,translate])
        rotate([90,0,0])
        cylinder(r=slide_crook_sleeve_radius, h=slide_crook_sleeve_length);
        outer_slide_tubes(extra_radius=slide_grip_inner_slide_clearance, solid=true);
    }
    /*difference() {
        translate([0,0,translate])
        rotate([90,0,0])

        translate([0,0,-5])
        cylinder(r1=slide_crook_sleeve_radius-5, r2=slide_crook_sleeve_radius, h=5);
        translate([0,1.2,0])
        outer_slide_tubes(extra_radius=slide_grip_inner_slide_clearance, solid=true);
        slide_bow(solid=true);
    }*/
}
    
module outer_slide_tubes(extra_radius=0, solid=false) {
  outer_slide_tube(extra_radius, solid, slide_crook_length);
  outer_slide_tube(extra_radius, solid, -slide_crook_length);  
}  

module inner_slide_tubes(extra_radius=0, solid=false) {
  inner_slide_tube(extra_radius, solid, slide_crook_length);
  inner_slide_tube(extra_radius, solid, -slide_crook_length);  
}  

module inner_slide_tube(extra_radius, solid, translate) {
    translate([100,0,translate])
    rotate([90,0,0])
    difference() {
        cylinder(r=inner_slide_tube_outer_radius + extra_radius, h=slide_tube_length+2);
        if(!solid) {
            cylinder(r=inner_slide_tube_inner_radius, h=slide_tube_length+2);
        }
    }
}
module outer_slide_tube(extra_radius=0, solid=false, translate) {
    translate([0,0,translate])
    rotate([90,0,0])
    difference() {
        cylinder(r=outer_slide_tube_outer_radius + extra_radius, h=slide_tube_length+2);
        if(!solid) {
            cylinder(r=outer_slide_tube_inner_radius + extra_radius, h=slide_tube_length+2);
        }
    }
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
        
        //the mouthpiece receiver can be larger diameter than your tube. in that case, you'll need
        //some extra tubing at the start. Let's render that
        mouthpiece_receiver_tube_length = 15;
        //length over which the inner slide will be glued
        inner_slide_glue_length=16;
        //  2. The mouthpiece receiver
        difference() {
            translate([100,0,0])
            top_oversleeve(oversleeve_radius, mouthpiece_receiver_tube_length);            
            leadpipe(extra_radius=0.1, solid=true, extra_outside_length=2);
        }
        

        //  3. The tubes in which the inner slide tubes will be glued
        //top
       difference() {
            translate([100,0,0])
            top_oversleeve(oversleeve_radius, inner_slide_glue_length, mouthpiece_receiver_tube_length);
            inner_slide_tubes(extra_radius=slide_grip_inner_slide_clearance, solid=true);
            leadpipe(extra_radius=0.1, solid=true);
        }//*/
        
        //and bottom
       difference() {
            translate([100,0,0])
            bottom_oversleeve(oversleeve_radius, mouthpiece_receiver_tube_length + inner_slide_glue_length);
            inner_slide_tubes(solid=true);
            leadpipe(extra_radius=0.1, solid=true);
        }
        
        

        //  4. The tubes in which outer the slide goes when in first position 
        slope_length=5;
        difference() {
            union() {
                translate([100,-slide_tube_length+mouthpiece_receiver_tube_length + inner_slide_glue_length-slope_length, slide_crook_length])
                rotate([-90,0,0])
                cylinder(r1=oversleeve_radius, r2=outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness, h=slope_length);
                
                translate([100,-slide_tube_length+mouthpiece_receiver_tube_length + inner_slide_glue_length-slope_length, -slide_crook_length])
                rotate([-90,0,0])
                cylinder(r1=oversleeve_radius, r2=outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness, h=slope_length);
            }
            inner_slide_tubes(solid=true);
            leadpipe(extra_radius=0.1, solid=true);
        }
        
        difference() {
            translate([100,0,0])
            union() {
                oversleeves(outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness, 25, mouthpiece_receiver_tube_length + inner_slide_glue_length);

            }
            translate([100,0,0])
            outer_slide_tubes(extra_radius=slide_grip_clearance);
        }//
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
        cylinder(r=inner_slide_tube_outer_radius + stocking_clearance, h=stockings_length);
    }
}


    

