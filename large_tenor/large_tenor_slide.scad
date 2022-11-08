/* Work in progress model of a slide. If you want to print this, be warned that this design is not finished - it has not been tested, the leadpipe quite a bit wrong and probably
parts do not assemble or otherwise fail
*/

use <../bent_tubes.scad>;

$fn=100;
sweep_steps=50;

//Bach 42B compatible slide distance. I measured my Bach 42B to have the same slide crook. 
//Distance between inner part of tubes 89.05
//Distance between outer part of tubes 120.0
//tube width 15.45
//(120.0-89.05)/2=15.475 -- close enough measurements!
//89.05+15.45=104.5mm between centers of tubes
//sooooo, 52.25 slide_crook_length (should be called width);
//that means 52.25*pi = 164.148 tube length in the crook

pi = 3.14159265359;

//slide_crook_tube_length=164.148;
//slide_crook_length=slide_crook_tube_length/pi;
slide_crook_length=52.35;//52.35 was the best so far, smaller=worse
slide_crook_tube_length = slide_crook_length*pi;
//the inner radius of the slide crook
slide_crook_radius=7.5;//15 mm diameter, with my 15/16 outers
slide_crook_wall_thickness=1.8; //to ensure airtightness.

//distance between the grip and the bell connector. here for ergonomic reasons, but 
//of course it changes tuning as well
extra_handgrip_distance=18;

echo(str("crook width: ", slide_crook_length, "mm"));

echo(str("crook tube length: ",slide_crook_tube_length), "mm");

slide_tube_length=700;  

//the distance between hand grip and end of inner slide

hand_grip_distance = 6.5;
oversleeve_length=50;

slide_crook_sleeve_length=30;


//outer are carbon tubes of ID 15, OD 16
//inner are carbon tubes of ID 12 OD 14
//inners would be better with only 0.5mm wall thickness instead of 1, but my tubes were specced wrong
//sometimes your tubes will have slightly different diameters. fun.
top_slide_grip_inner_slide_clearance=0.10;
bottom_slide_grip_inner_slide_clearance=0.14;

slide_grip_clearance = 1.2;
slide_grip_wall_thickness=1.8;

//the inner radius of the inner slide tube
inner_slide_tube_inner_radius=13.7/2;;
//the outer radius of the inner slide tube
inner_slide_tube_outer_radius=16.1/2;//(25.4*(5/8))/2;
//the inner radius of the outer slide tube
outer_slide_tube_inner_radius=16.7/2;
//the outer radius of the outer slide tube
outer_slide_tube_outer_radius=(25.4*(3/4))/2;

outer_slide_grip_radius=6.5;

bell_connector_small_radius = 50/pi/2;
bell_connector_large_radius = 54.7/pi/2;
bell_connector_length = 31.5;

stockings_length=90;
stocking_clearance=0.1;
stocking_wall_thickness=0.46;

//the part to render
part = "all"; // [all, crook, stockings, leadpipe, inner_grip, outer_grip]

echo("stocking wall thickness:");
echo(stocking_wall_thickness);
slide_crook_sleeve_radius=outer_slide_tube_outer_radius+slide_crook_wall_thickness;

/* [MOUTHPIECE RECEIVER] */
shank="large"; // [small, large]
//mouthpiece_receiver_length = (shank == "small") ? 33 : 38;
//mouthpiece_receiver_small_radius = ((shank == "large") ? 6 : 5);
//according to bach guide: 13.867 and 12.6, 1 inch long
//mouthpiece_receiver_large_radius = ((shank == "large") ? 12.7 : 11)/2;

//this is according to bach mouthpiece guide, page 32. Will need extra clearance here too
mouthpiece_receiver_clearance = 0.1;
mouthpiece_receiver_length = (shank == "large") ? 25.4 : 25.4*17/16;
mouthpiece_receiver_small_radius = mouthpiece_receiver_clearance + ((shank == "large") ? 0.496*25.4 : 0.422*25.4)/2;
mouthpiece_receiver_large_radius = mouthpiece_receiver_clearance + ((shank == "large") ? 0.546*25.4 : 0.475*25.4)/2;
echo("receiver outer/inner/length:");
echo(mouthpiece_receiver_large_radius*2+0.4*2);
echo(mouthpiece_receiver_small_radius*2+0.4*2);
echo(mouthpiece_receiver_length);

/*
#inner_slide_tube

/* [LEAD PIPE] */
leadpipe_minimum_wall_thickness=0.45;
leadpipe_length=199.8;
//the amount of space between leadpipe and inners (radius, not diameter)
leadpipe_clearance=0.04;
//the first part of the leadpipe is outside of the slide so the mouthpiece fits and 
//the leadpipe can be removed from the trombone slide
leadpipe_outside_slide_bit_length=4;
//which needs a wall thickness
leadpipe_outside_slide_bit_wall_thickness=1.2;

//leadpipe outer bit can be straight or conical
straight_leadpipe_outer_bit=false;


//TODO: set these parameters to produce a good leadpipe!
leadpipe_venturi_radius=12/2;//could be about right for a 12mm bore slide
leadpipe_venturi_distance_from_mouthpiece_receiver=70-mouthpiece_receiver_length;//just a guess, based on a large bore leadpipe
//do not change unless you have a very small nozzle that can print tiny very strong walls :)
leadpipe_end_radius=inner_slide_tube_inner_radius - leadpipe_clearance - leadpipe_minimum_wall_thickness;



oversleeve_wall_thickness=1.8;

oversleeve_radius = mouthpiece_receiver_large_radius + leadpipe_outside_slide_bit_wall_thickness + 0.45 + oversleeve_wall_thickness;
top_oversleeve_radius = oversleeve_radius;
bottom_oversleeve_radius = inner_slide_tube_outer_radius+oversleeve_wall_thickness;

outer_oversleeve_wall_thickness = 1.2;

outer_oversleeve_radius = outer_slide_tube_outer_radius + top_slide_grip_inner_slide_clearance + outer_oversleeve_wall_thickness;


echo("leadpipe venturi/end diameter:");
echo(leadpipe_venturi_radius*2);
echo(leadpipe_end_radius*2);

if(part == "all") {
    #inner_slide_tubes();
    #outer_slide_tubes();

    slide_crook();

    outer_slide_grip();



    stockings();
    leadpipe();


    inner_slide_grip();
} else if ( part == "crook") {
    slide_crook();
} else if (part == "stockings") {
    stockings();
} else if (part == "inner_grip") {
    inner_slide_grip();
} else if (part == "outer_grip"){
    outer_slide_grip();
} else if (part == "leadpipe") {
    leadpipe();
}
//intersection() {

 //   translate([20,0,0])
 //   rotate([90, 0, 0])
 //   union() {
 //       mouthpiece_receiver();
 //       leadpipe_inner_shape();
 //   }

//inner_slide_glueing_tubes(15, 16);
//slope_to_outer_slide_receiver(15, 16);
//leadpipe();

//leadpipe(solid=true);
//outer_slide_grip();
//slide_crook();
//translate([100,0,0])
//    top_oversleeve(13, 100, solid=true);
//}//*/
//stocking();
//slide_crook_sleeve(slide_crook_length);
//slide_crook();
//outer_slide_grip();
//stocking();
//leadpipe_straight_outer_shape();
/*difference() {
    outer_slide_grip();
    translate([-20, -slide_tube_length-5 , -slide_crook_length-100]) cube(100);
    translate([-20, -slide_tube_length-5 , +slide_crook_length]) cube(100);
}*/
/* renders a leadpipe with the set parameters, that can have extra_radius.
it can be solid or not and it can have a bit of extra length at the outside
 */
module leadpipe(extra_radius=0, solid=false, extra_outside_length=0, outer_shape_straight=true) {
    translate([100,-slide_tube_length-0, slide_crook_length])
    rotate([180,0,0])
    rotate([90, 0, 0])
    union() {
        difference() {
            if(outer_shape_straight) {
                leadpipe_straight_outer_shape(extra_radius+leadpipe_minimum_wall_thickness);
            } else {
                leadpipe_inner_shape(extra_radius+leadpipe_minimum_wall_thickness);
            }
            if(!solid) {
                leadpipe_inner_shape(extra_radius);
            }
        }
        difference() {
            leadpipe_outer_bit(extra_radius, extra_outside_length);
            mouthpiece_receiver(extra_radius);
            if(!solid) {
                leadpipe_inner_shape(extra_radius);
            }
        }
    }
}

module leadpipe_outer_bit(extra_radius=0, extra_outside_length=0) {
    union() {
        if(straight_leadpipe_outer_bit) {
            //part of tube outside of slide
            cylinder(r=mouthpiece_receiver_large_radius + extra_radius + leadpipe_outside_slide_bit_wall_thickness, h=leadpipe_outside_slide_bit_length);
            if(extra_outside_length > 0) {
                translate([0,0,-extra_outside_length])
                cylinder(r=mouthpiece_receiver_large_radius + extra_radius + leadpipe_outside_slide_bit_wall_thickness, h=extra_outside_length);
            }
        } else {
            //conical bit that should seal better
             //part of tube outside of slide
            cylinder(r1=mouthpiece_receiver_large_radius + extra_radius + leadpipe_outside_slide_bit_wall_thickness,
                r2=inner_slide_tube_inner_radius - leadpipe_clearance,
                h=leadpipe_outside_slide_bit_length);
            if(extra_outside_length > 0) {
                translate([0,0,-extra_outside_length])
                cylinder(r=mouthpiece_receiver_large_radius + extra_radius + leadpipe_outside_slide_bit_wall_thickness, h=extra_outside_length);
            }
        }
    }
}

//straight-ish outer shape - cannot always be straight or with some tube radiuses the mouthpiece receiver won't fit in the tube :)
module leadpipe_straight_outer_shape(extra_radius=0) {
   radius = inner_slide_tube_inner_radius - leadpipe_clearance;//even with extra radius, don't make it bigger than this, never!
    union() {
        cylinder(
            r1=max(mouthpiece_receiver_large_radius+extra_radius, radius), 
            r2=max(mouthpiece_receiver_small_radius+extra_radius, radius),
            h=mouthpiece_receiver_length)
        ;
        
        translate([0,0,0])
        cylinder(
            r1=max(mouthpiece_receiver_small_radius+extra_radius, radius), 
            r2=max(leadpipe_venturi_radius+extra_radius, radius),  
            h=leadpipe_length
        );
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
        oversleeves(outer_oversleeve_radius, outer_oversleeve_radius, oversleeve_length);
    };
    
    difference() {
        oversleeves(outer_oversleeve_radius, outer_oversleeve_radius, oversleeve_length);
        outer_slide_tubes(top_slide_grip_inner_slide_clearance, true);
    }
}

module oversleeves(top_radius, bottom_radius, length, start_position=0) {
    top_oversleeve(top_radius, length, start_position);
    bottom_oversleeve(bottom_radius, length, start_position);
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

/* looks cool, print withtou support?*/

module slide_crook_insert() {
        inset_height=1.2;
        rotate([0,90,0])
        translate([0,0,-inset_height/2])
        linear_extrude(height=inset_height, scale=[1,1], twist=0) {
            difference() {
                circle(r=slide_crook_length);
                                    rotate([0,0, 90])
                translate([0,0])
                scale([1,1.3])
                circle(r=slide_crook_length-15, $fn=3);
                translate([-150,-230])
                square(200);
            }
        }
        
        rotate([0,90,0])
        rotate_extrude(angle=180){
            translate([slide_crook_length-7.9,0])
            rotate([0,180])
            scale([1,2.2])
            circle($fn=3, r=3.5);
        }
}    
module slide_crook() {

    difference() {
        union() {
            //the connection between the slide bow and sleeves needs a gradual diameter change
            difference() {
                union() {
                    translate([0,3,slide_crook_length])
                    rotate([90,0,0])
                    cylinder(r1=slide_crook_radius+slide_crook_wall_thickness-0.1, r2=slide_crook_sleeve_radius, h=3);
                    translate([0,3,-slide_crook_length])
                    rotate([90,0,0])
                    cylinder(r1=slide_crook_radius+slide_crook_wall_thickness-0.1, r2=slide_crook_sleeve_radius, h=3);
                    
                   //slide_crook_insert();
                }
                slide_bow(solid=true);
                slide_crook_sleeve(slide_crook_length, solid=true);
                slide_crook_sleeve(-slide_crook_length, solid=true);
            }
            slide_bow(solid=false);
            slide_crook_sleeve(slide_crook_length);
            slide_crook_sleeve(-slide_crook_length);
        }

    }
    
}

//slide_end_stops();
//little things to put on the top of the outer slides to prevent damage to the
//relatively fragile ends of the carbon fiber tubes
module slide_end_stops() {
    clearance = 0.04;
    wall_overlap=0.4;

    difference() {
        cylinder(r=max(9, outer_slide_tube_outer_radius+clearance+0.8), h=3.5);
        translate([0,0,2.5])
        cylinder(r=outer_slide_tube_outer_radius +clearance - wall_overlap,h=1);
        cylinder(r=outer_slide_tube_outer_radius + clearance,h=2.5);
    }
}

module slide_bow(solid=false) {

    
    rotate([0,90,0])

    rotate_extrude(angle=180, $fn=sweep_steps) {
        difference() {
            translate([slide_crook_length, 0, 0])
            rotate([0,0,90])
            circle(r=slide_crook_radius+slide_crook_wall_thickness);
            if(!solid) {
                translate([slide_crook_length, 0, 0])
                circle(r=slide_crook_radius);
            }
        }
    };

}

//Work in progress
module straight_slide_bow(solid=false) {

    
    rotate([0,90,0])

    translate([slide_crook_length/3, 0, 0])
    rotate_extrude(angle=90, $fn=sweep_steps) {
        difference() {
            translate([slide_crook_length/1.5, 0, 0])

            circle(r=slide_crook_radius+slide_crook_wall_thickness, center=true);
            if(!solid) {
                translate([slide_crook_length, 0, 0])
                circle(r=slide_crook_radius, center=true);
            }
        }
    }
    
    rotate([0,-90,0])
    translate([slide_crook_length/3, 0, 0])
    rotate_extrude(angle=90, $fn=sweep_steps) {
        difference() {
            translate([slide_crook_length/1.5, 0, 0])

            circle(r=slide_crook_radius+slide_crook_wall_thickness, center=true);
            if(!solid) {
                translate([slide_crook_length, 0, 0])
                circle(r=slide_crook_radius, center=true);
            }
        }
    }
    
   translate([0,slide_crook_length/1.5, -slide_crook_length/3])
    difference() {     
        cylinder(r=slide_crook_radius+slide_crook_wall_thickness, h=slide_crook_length/1.5);
        if(!solid) {
            cylinder(r=slide_crook_radius, h=slide_crook_length/1.5);
        }
    }

}

module slide_bow_print_helper() {
    triangle_length = 30;
    translation_thingy = (slide_crook_radius+slide_crook_wall_thickness)/2;
    translate([-triangle_length/2, slide_crook_length, 0])
    rotate([0,90,0])
    cylinder($fn=6, r=slide_crook_radius+slide_crook_wall_thickness, h=triangle_length);

    translate([-18.67, slide_crook_length-4.3, 0])
    rotate([-35,90,0])
    cylinder($fn=6, r=slide_crook_radius+slide_crook_wall_thickness, h=5);

    translate([triangle_length/2-translation_thingy, slide_crook_length-0.8+translation_thingy/2, 0])
    rotate([35,90,0])
    cylinder($fn=6, r=slide_crook_radius+slide_crook_wall_thickness, h=8);
}

module slide_crook_sleeve(translate, solid=false) {
    difference() {
        translate([0,0,translate])
        rotate([90,0,0])
        cylinder(r=slide_crook_sleeve_radius, h=slide_crook_sleeve_length);
        if(!solid) {
            outer_slide_tubes(extra_radius=top_slide_grip_inner_slide_clearance, solid=true);
        }
    }
}
    
module outer_slide_tubes(extra_radius=0, solid=false) {
  outer_slide_tube(extra_radius, solid, slide_crook_length);
  outer_slide_tube(extra_radius, solid, -slide_crook_length);  
}  

module inner_slide_tubes(extra_radius=0, solid=false) {
  inner_slide_tube(extra_radius, solid, bottom=false);
  inner_slide_tube(extra_radius, solid, bottom=true);  
}  

module inner_slide_tube(extra_radius, solid, bottom) {
    translate([100,0,bottom ? -slide_crook_length: slide_crook_length])
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
    union() {
       
        mouthpiece_receiver_tube_length = 15;
        //length over which the inner slide will be glued
        inner_slide_glue_length=16;
        
        inner_slide_brace();
        
        extra_tubing_for_mouthpiece(mouthpiece_receiver_tube_length, inner_slide_glue_length);
        

        inner_slide_glueing_tubes(mouthpiece_receiver_tube_length, inner_slide_glue_length);
        
        outer_slide_receiver_tubes(mouthpiece_receiver_tube_length, inner_slide_glue_length);
   
        translate([100,0,0])
        bell_connector();
    }
}


module inner_slide_brace() {
     //1. the brace that you grip with your hand
        difference() {
            translate([100, -slide_tube_length + hand_grip_distance, -slide_crook_length])
            cylinder(r=outer_slide_grip_radius, h=slide_crook_length*2);
            translate([100,0,0])
            oversleeves(top_oversleeve_radius, bottom_oversleeve_radius, 50);
        };
}

module extra_tubing_for_mouthpiece(mouthpiece_receiver_tube_length, inner_slide_glue_length) {
        //the mouthpiece receiver can be larger diameter than your tube. in that case, you'll need
        //some extra tubing at the start. Let's render that

    //  2. The mouthpiece receiver
    difference() {
        translate([100,0,0])
        top_oversleeve(top_oversleeve_radius, mouthpiece_receiver_tube_length);            
        leadpipe(extra_radius=0.1, solid=true, extra_outside_length=2);
    }
}

module inner_slide_glueing_tubes(mouthpiece_receiver_tube_length, inner_slide_glue_length) {
    
        //  3. The tubes in which the inner slide tubes will be glued
        //top
       difference() {
            translate([100,0,0])
            top_oversleeve(top_oversleeve_radius, inner_slide_glue_length, mouthpiece_receiver_tube_length);
            inner_slide_tube(extra_radius=top_slide_grip_inner_slide_clearance, solid=true, bottom=false);
            leadpipe(extra_radius=0.1, solid=true);
        }//*/
        
        //and bottom
       difference() {
            translate([100,0,0])
            bottom_oversleeve(bottom_oversleeve_radius, mouthpiece_receiver_tube_length + inner_slide_glue_length);
            inner_slide_tube(extra_radius=bottom_slide_grip_inner_slide_clearance, solid=true, bottom=true);
            leadpipe(extra_radius=0.1, solid=true);
        }
}

module outer_slide_receiver_tubes(mouthpiece_receiver_tube_length, inner_slide_glue_length) {
         //  4. The tubes in which outer the slide goes when in first position 
       slope_to_outer_slide_receiver(mouthpiece_receiver_tube_length, inner_slide_glue_length);
        
        //the tubes
        local_outer_oversleeve_radius = outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness;
        difference() {
            translate([100,0,0])
            union() {
                oversleeves(local_outer_oversleeve_radius, local_outer_oversleeve_radius, 25, mouthpiece_receiver_tube_length + inner_slide_glue_length);

            }
            translate([100,0,0])
            outer_slide_tubes(extra_radius=slide_grip_clearance, solid=true);
        }//
}

module slope_to_outer_slide_receiver(mouthpiece_receiver_tube_length, inner_slide_glue_length) {
     slope_length=5;
    //the sloping part
    difference() {
            translate([100,-slide_tube_length+mouthpiece_receiver_tube_length + inner_slide_glue_length-slope_length, slide_crook_length])
            rotate([-90,0,0])
            cylinder(r1=top_oversleeve_radius, r2=outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness, h=slope_length);
            inner_slide_tube(extra_radius=top_slide_grip_inner_slide_clearance, solid=true, bottom=false);
            leadpipe(extra_radius=top_slide_grip_inner_slide_clearance, solid=true);
    }
    difference() {
            translate([100,-slide_tube_length+mouthpiece_receiver_tube_length + inner_slide_glue_length-slope_length, -slide_crook_length])
            rotate([-90,0,0])
            cylinder(r1=bottom_oversleeve_radius, r2=outer_slide_tube_outer_radius+slide_grip_clearance+slide_grip_wall_thickness, h=slope_length);
           inner_slide_tube(extra_radius=bottom_slide_grip_inner_slide_clearance, solid=true, bottom=true);
    }
            

}


module bell_connector() {
    translate([0, -slide_tube_length, -slide_crook_length])
    rotate([90,0,0])
    union() {
        difference() {
            union() {
                cylinder(r=bottom_oversleeve_radius, h=extra_handgrip_distance-3);
                translate([0, 0, extra_handgrip_distance-3])
                cylinder(r1=bottom_oversleeve_radius, r2=bell_connector_large_radius, h=3);
            }
           cylinder(r=inner_slide_tube_inner_radius, h=extra_handgrip_distance);
        }
        translate([0, 0, extra_handgrip_distance]) {
        difference() {
                cylinder(r1=bell_connector_large_radius, r2=bell_connector_small_radius, h=     bell_connector_length);
                cylinder(r=inner_slide_tube_inner_radius, h=bell_connector_length);
        }
    }
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




    

