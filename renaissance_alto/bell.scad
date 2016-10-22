/**
Something like a renaissance alto bell for the Jinbao alto. WARNING: This is not an accurate reproduction of a historic instrument!
Bore reducers for the inner slide are probably possible if you remove the lead pipe, they should be added later

This file still needs work so it can be integrated with the generic bell and tuning slide scripts
*/

use <Curved_Pipe_Library_for_OpenSCAD/curvedPipe.scad>;

use <../bessel.scad>;

$fn = 20;
//tuning_slide(solid=false) module renders a tuning slide, using the sweep module.
include <tuning_slide.scad>;

$fn = 20;


bell_radius = 94/2;

slide_receiver_tolerance = -0.02;

connection_base_clearance = 0.15;

slide_receiver_small_radius = 14/2;
slide_receiver_large_radius = 15/2;

slide_receiver_sleeve_length=10;//make this short or it looks absolutely ridiculous

//extra width added to the slide receiver to match the slide

slide_receiver_length=33.5 + slide_receiver_tolerance;

// the thumb brace should be positioned for easy holding, so close to the slide
neckpipe_bell_connection_height = -279.5;

render_neckpipe_bases = true;

part = "all";//bell_bottom;bell_middle;bell_top;tuning_slide;neckpipe_top;neckpipe_bottom;connection_bottom;connection_top; tube_connector_test_bottom;tube_connector_test_top;slide_receiver_test;tuning_slide_test;connection_test_one;connection_test_two

other_wall_thickness = 1.2;

bell_thickness = 1.2;
joint_extra_thickness = 1.2;
joint_length = 5; //length of the glue joint
joint_overlap = 3; //length that the joint sleeve overlaps the bell
joint_clearance = 0.13; //we need some joint clearance, obviously

joint_width = 6.5;
joint_depth = 9;
//for your joint to have a nice looking and printable bottom, set this higher
joint_slanted_bottom = 20;
//the receiver should be slightly longer than the slide
tuning_sleeve_extra_length = 0;

lip_start=2;
lip_end=5;
lip_slant=1;
lip_length=7;
//difference in size between the joint outer and inner lip
//so they can fit together without requiring too much use of sandpaper
// i need better words for this :)
lip_offset = 0.1;

//difference between outer diameter of tuning slide and inner diameter of sleeve in mm
tuning_slide_spacing = 0.1;

neck_pipe_length = 152 + 25;//jinbao slide is a bit short, so we have to make this a bit longer
neck_pipe_radius = 9.25/2;

neckpipe_bell_connection_radius=6.5;

neck_pipe_minus_tuning_slide_receiver_length = neck_pipe_length - tuning_slide_small_length -tuning_sleeve_extra_length;

lip = [[lip_start, 0], [lip_start+lip_slant, lip_length], [lip_end-lip_slant, lip_length], [lip_end, 0]];

inner_lip = [[lip_start+lip_offset, 0], [lip_start+lip_slant +lip_offset, lip_length-lip_offset], [lip_end-lip_slant-lip_offset, lip_length-lip_offset], [lip_end-lip_offset, 0]];

total_bell_height = -450+40; //TODO: make this with proper parameters. Why did i not inclue the tuning slide receiver in the total bell height?

echo(total_bell_height);


tuning_slide_large_receiver_inner_radius = tuning_slide_large_radius + tuning_slide_wall_thickness + tuning_slide_spacing;

//steps of the bessel curve for loop
steps=90;
   

    
first_bell_cut = 0;
second_bell_cut = -195;
third_bell_cut = second_bell_cut - 150;
fourth_bell_cut = third_bell_cut - 185;


echo("inner:");
echo(tuning_slide_large_receiver_inner_radius);
echo(tuning_slide_large_radius);

//94mm = 49mm
//everything times 1.92
//-8.09 height, 49-8.5*2=32mm measured
//-45mm height, 49-15 = 

/*
Array of input. First element defines type:
["CYLINDER", radius, length]
["CONE", r1, r2, length]
["BESSEL", r_small, r_large, flare, length]
*/
bell_input = [
    ["CYLINDER", tuning_slide_large_receiver_inner_radius, 40],
    ["CONE", 10.2/2, 10.3/2, 15],
    ["CONE", 10.3/2, 12.7/2, 44],
    ["BESSEL", 14.7/2, 23/2, 1.260, 223],
    ["BESSEL", 23/2, 37/2, 0.894, 72],
    ["BESSEL", 37/2, 61.8/2, 0.7, 36.6],
    ["BESSEL", 61.8/2, bell_radius, 1, 14.37], 
];

bell_polygon = create_bell_profile(bell_input);

    
//length 14.37, 61.8mm diameter
//length 51mm - 37mm diameter
//length 123, 23mm diameter
//length 346, 12.7mm diameter

rotate([180,0,0]) {

    //temporary render for a test
    //translate([0,0,400])
    if(part == "tube_connector_test_top") {
        render_bell_segment(render_bottom_lip=true, render_top_lip=false, min_height=-410, max_height=-400);
    }
    if(part == "tube_connector_test_bottom") {
        render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=-400, max_height=-380);
    }
    if(part == "slide_receiver_test") {
        slide_receiver(other_wall_thickness);
    }
    if(part == "tuning_slide_test_one") {
        tuning_slide_test_one();
    }
    if(part == "tuning_slide_test_two") {
        tuning_slide_test_two();
    }
    if(part == "connection_test_one") {
        
    }
    if(part == "connection_test_two") {
        
    }

    //solid_bell();



    //three part bell section render
    
    if(part == "all" || part == "bell_top") {
        union() {
            render_bell_segment(render_bottom_lip=true, render_top_lip=false, min_height=fourth_bell_cut, max_height=third_bell_cut);
        }
    }
    
    if(part == "all" || part == "bell_middle") {
        union() {
            render_bell_segment(render_bottom_lip=true, render_top_lip=true, min_height=third_bell_cut, max_height=second_bell_cut);
          lower_bell_connection_base();
        }
    }
    if(part == "all" || part == "bell_bottom") {
        render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=second_bell_cut, max_height=first_bell_cut,render_flat_bottom_lip=false);
          //TODO: move
    }


    //two part bell - for very high printers!
    /*union() {
        render_bell_segment(render_bottom_lip=true, render_top_lip=false, min_height=-580, max_height=-290);
        bell_connection_bases();
    }*/
    //render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=-290, max_height=0);


    if(part == "all") {
       // translated_tuning_slide();
    }
    if(part == "tuning_slide") {
        tuning_slide();
    }

    //#check_slide_clearance(other_wall_thickness);


    if(part == "all" || part == "neckpipe") {        
//        rotate([-90,0,0]) {
            neckpipe(other_wall_thickness);
            bell_side_neckpipe_bell_connection();
//            tuning_slide_side_neckpipe_bell_connection();
  //      }
    }

    if(part == "test_1") {
        intersection() {
            translate([0, 500,-150])
            rotate([-90,0,0]) {
        top_part_of_neckpipe(other_wall_thickness);

            };
                    translate([-50,12,-75])
            cube(100);
        }
    }
    
    if(part == "test_2") {


                intersection() {
                bell_side_neckpipe_bell_connection();
            translate([-50,-220,-375])
                                cube(100);

        }
    }
    

    if(part == "all" || part == "connection_bottom") {
        bell_side_neckpipe_bell_connection();
    }

}

module render_bell_bottom() {
    
    extra_height  = 0.87; //TODO: get exact height from bell_polygon
    union() {
        render_bell_segment(render_bottom_lip=false, render_top_lip=false, min_height=first_bell_cut, max_height=0);

    /* difference() {
                rotate_extrude() 
                polygon([ [55, -1], [bell_radius+1, -1], [60, first_bell_cut-extra_height], [55, first_bell_cut-extra_height]]);
                solid_bell();
        }*/
    }
}

module  tuning_slide_test_one() {
    //print only the small tuning slide peg thing
    intersection() {
        tuning_slide();
        translate([-50,-100,0])
        cube(100);
    }
}

module  tuning_slide_test_two() {

        intersection() {
            small_tuning_slide_sleeve(other_wall_thickness);
            translate([-200,-200,-1050])
            cube(500);
        }
}    

module check_slide_clearance(wall_thickness) {
    neckpipe_implementation(wall_thickness,
			    neck_pipe_radius,
        false, check_slide_clearance=true);
}

module translated_tuning_slide() {
    translate([0,-tuning_slide_radius,total_bell_height-tuning_slide_small_length]) {
        rotate([270,0,0]) {
            tuning_slide();
        }
    };
}

module slide_receiver(wall_thickness, solid = false) {

    
    if(!solid) {
        difference() {
            cylinder(r2=slide_receiver_large_radius + wall_thickness, r1=slide_receiver_small_radius +wall_thickness, h=slide_receiver_length);
            cylinder(r2=slide_receiver_large_radius, r1=slide_receiver_small_radius, h=slide_receiver_length);
        };
    } else {
            cylinder(r2=slide_receiver_large_radius + wall_thickness, r1=slide_receiver_small_radius +wall_thickness, h=slide_receiver_length);
    }
    
        edge_for_locknut_length=2.5;
    edge_for_locknut_thickness = 1.5;
        translate([0,0,slide_receiver_length-edge_for_locknut_length])
        if(solid){
            cylinder(r=slide_receiver_large_radius + wall_thickness+edge_for_locknut_thickness, h=edge_for_locknut_length);
        } else {
       
            difference() {
                cylinder(r=slide_receiver_large_radius + wall_thickness+edge_for_locknut_thickness, h=edge_for_locknut_length);
                cylinder(r=slide_receiver_large_radius + wall_thickness, h=edge_for_locknut_length);
            }
        }
        if(!solid) {
            //sleeve to make a good connection to the neckpipe - which could be less wide than this!
            translate([0,0,-slide_receiver_sleeve_length])
            difference() {
                cylinder(r2=slide_receiver_small_radius + wall_thickness, r1=neck_pipe_radius+wall_thickness, h=slide_receiver_sleeve_length);
                cylinder(r2=slide_receiver_small_radius, r1=neck_pipe_radius, h=slide_receiver_sleeve_length);
            }
        } else {
            //sleeve to make a good connection to the neckpipe - which could be less wide than this!

            translate([0,0,-slide_receiver_sleeve_length])
                cylinder(r2=slide_receiver_small_radius + wall_thickness, r1=neck_pipe_radius+wall_thickness, h=slide_receiver_sleeve_length);
        }            
}

module bell_side_neckpipe_bell_connection() {
    neckpipe_bell_connection(neckpipe_bell_connection_height);
}

module tuning_slide_side_neckpipe_bell_connection() {
    neckpipe_bell_connection(-530);

}


module neckpipe_bell_connection(height) {

        difference() {
            translate([0,0,height])
            rotate([90,0,0])
            cylinder(h = tuning_slide_radius*2, r=neckpipe_bell_connection_radius);
            solid_neckpipe(other_wall_thickness);
            solid_bell();

            connection_bases(connection_base_clearance);
        }        
     


}

module bottom_part_of_neckpipe(wall_thickness) {
    intersection() {
        translate([-50, -tuning_slide_radius*2-50, -480])
        cube(190);
           neckpipe(wall_thickness);
    }
    translate([0, -tuning_slide_radius*2, -480])
    rotate_extrude()
    
    top_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true);
}


module top_part_of_neckpipe(wall_thickness) {
    intersection() {
        translate([-50, -tuning_slide_radius*2-50, -670])
        cube(190);
                   neckpipe(wall_thickness);
    }
    bottom_joint_height=10;
    translate([0, -tuning_slide_radius*2, -670+190-bottom_joint_height])
    rotate_extrude()
    
    bottom_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true);
}

module neckpipe(wall_thickness) {
    neckpipe_implementation(wall_thickness,
			    neck_pipe_radius,
        false);
    
    neckpipe_connection_bases();
    
    //TODO: slide locknut
    //TODO: split in separate parts so it can be printed
}

//a solid neckpipe. useful in difference with some other things
module solid_neckpipe(wall_thickness) {
    neckpipe_implementation(wall_thickness, neck_pipe_radius, solid=true);

}


//length 152mm
module neckpipe_implementation(wall_thickness, neck_pipe_radius, solid=false, check_slide_clearance=false) {


        if(solid) {
            solid_small_tuning_slide_sleeve(other_wall_thickness);
        } else {
            small_tuning_slide_sleeve(other_wall_thickness);
        }

        od = neck_pipe_radius*2 + wall_thickness+2;
        id = solid? 0.0005 : neck_pipe_radius*2;

        //renaissance style trombone with tiny bell. That means NO gooseneck needed.

        slide_receiver_begin = neck_pipe_minus_tuning_slide_receiver_length -slide_receiver_length;


        //neck pipe, including gooseneck
        translate([0, -tuning_slide_radius *2, total_bell_height + tuning_sleeve_extra_length])
        if(solid) {
            cylinder(h=slide_receiver_begin, r=od/2);
        } else {
            difference() {
                cylinder(h=slide_receiver_begin, r=od/2);
                cylinder(h=slide_receiver_begin, r=id/2);
            };
        }
    
        //slide receiver
        translate([0, -tuning_slide_radius *2-0, total_bell_height + tuning_sleeve_extra_length + slide_receiver_begin])
        slide_receiver(wall_thickness, solid);
    

    
    if(check_slide_clearance) {
        translate([0, -tuning_slide_radius *2-goose_neck_offset, total_bell_height + tuning_sleeve_extra_length + slide_receiver_begin])    
            rotate([goose_neck_angle, 0, 0])
            cylinder(r=5, h=730);

    }
}

module connection_bases(tolerance=0.0) {
    neckpipe_connection_bases(tolerance);
    bell_connection_bases(tolerance);
    
}

module neckpipe_connection_bases(tolerance=0.0) {

   // neckpipe_connection_base(16, neckpipe_bell_connection_height, tolerance);
}

module neckpipe_connection_base(translation, height, tolerance) {
    difference() {
        translate([0,-tuning_slide_radius*2+translation, height-3])
        rotate([70,0,0])
        scale([1,1,1])
        cylinder(r2=6.3+tolerance, r1=3+tolerance, h=19, $fn=8);  
        neckpipe_implementation(other_wall_thickness, neck_pipe_radius, true);
    }
}

module bell_connection_bases(tolerance=0.0) {

    lower_bell_connection_base();
}


module lower_bell_connection_base(tolerance=0.0) {
    bell_connection_base(neckpipe_bell_connection_height, tolerance);
}    

module bell_connection_base(height, tolerance) {

    cylinder_height=19; 
    difference() {
        translate([0, -bell_radius_at_height(bell_polygon, height-4)-cylinder_height+5, height-4])
        rotate([-70,0,0])
        scale([1,1,1])
        cylinder(r2=6.3+tolerance, r1=3+tolerance, h=cylinder_height, $fn=8);  
        solid_bell();
        }
}

module small_tuning_slide_sleeve(wall_thickness, solid=false) {
    translate([0, -tuning_slide_radius *2, total_bell_height-tuning_slide_small_length])
    difference() {
        cylinder(h = tuning_slide_small_length + tuning_sleeve_extra_length, r = tuning_slide_small_radius + tuning_slide_wall_thickness + tuning_slide_spacing + wall_thickness);
        if(!solid) {
            cylinder(h = tuning_slide_small_length + tuning_sleeve_extra_length, r =    tuning_slide_small_radius + tuning_slide_wall_thickness + tuning_slide_spacing);
        }
    };
    
    translate([0, -tuning_slide_radius *2, total_bell_height])
    difference() {
        cylinder(h=8, r2=neck_pipe_radius+wall_thickness, r1=tuning_slide_small_radius + +tuning_slide_wall_thickness + tuning_slide_spacing + wall_thickness);
        if(!solid) {
            cylinder(h=20, r=neck_pipe_radius);
        }
    }
}

module solid_small_tuning_slide_sleeve(wall_thickness) {
    small_tuning_slide_sleeve(wall_thickness, solid=true);
}

module render_bell_segment(render_bottom_lip, render_top_lip, min_height, max_height, render_flat_bottom_lip=false) {
    //rath R4 profile
    
    // leadpipe 26.145 mouthpiece ends at 0.664 mm
    // 0.695 inner slide diameter, 139.439 cm long (extends, of course)
    //  0.725 neck pipe,  26.910 cm long
   
    
    polygon = cut_curve(bell_polygon, min_height, max_height);

    //TODO: cut polygon at desired height and start at desired height
    //for the current part
    
    //render the joint to be glued

    echo("start and end of polygon: " );
    echo(polygon[0]);
        echo(polygon[len(polygon)-1]);

echo("thickness polygon:" );
    echo(len(polygon));

    rotate_extrude()

    union() {
        extrude_line(polygon, bell_thickness, solid=false);
        if(render_top_lip) {
            top_joint(polygon);                
        };
        if(render_bottom_lip) {
            bottom_joint(polygon); 
        }            
        if (render_flat_bottom_lip) {
            flat_bottom_joint(bell_polygon, min_height, max_height);
        } 
    }
  //  translate(polygon[0] + [0,-1])
//        polygon(inner_lip);
}

module solid_bell() {
    
    rotate_extrude()   
    bell_profile();
}

module bell_profile() {
    extrude_line(bell_polygon, bell_thickness, solid=true);
}


/* render a joint at top of tube. rotate=true means the male part is up instead of down*/
module top_joint(polygon, rotate=false) {

    difference() {
        translate(polygon[0]) {
            if(rotate) {
                union() {
                    polygon([[0, 0], [0, joint_slanted_bottom], [0, joint_depth], [joint_width, 0]]);
//                    polygon([[0, 0], [0, joint_slanted_bottom], [joint_width, joint_depth], [joint_width, 0]]);
                    rotate([0,180,180])
                    polygon(inner_lip);
                };
            } else {
                difference() {
                    polygon([[0, 0], [0, joint_slanted_bottom], [joint_width, joint_depth], [joint_width, 0]]);
                    polygon(lip);
                };
            };
        };
        extrude_line(polygon, 0, true);
    };
}

/* render a joint at bottom of tube. rotate=true means the male part is up instead of down*/
module bottom_joint(polygon, rotate=false) {
    difference() {
        translate(polygon[len(polygon)-1]) {
            if(rotate) {
                difference() {
                    rotate([0,180,180])
                    polygon([[0, 0], [0, joint_slanted_bottom], [joint_width, joint_depth], [joint_width, 0]]);
                rotate([0,180,180])
                  polygon(lip);
                }
            } else {           
                union() {    
                  polygon([[0, 0], [0, -joint_slanted_bottom], [0, -joint_depth], [joint_width, 0]]);
                  polygon(inner_lip);
                }
  
            }
        };
        extrude_line(polygon, 0, solid=true);
    };
}

module flat_bottom_joint(full_curve, min_height, max_height) {
   curve = cut_curve(full_curve, max_height-joint_overlap, max_height+joint_length);
   //TODO: nice smooth edge difference() {
    //    polygon([curve[0]+10, [0, curve[0][1]-2000], [0, curve[0][1]]]);
  //      bell_profile();
//    }
    union() {
        difference() {
            extrude_line(curve, bell_thickness + joint_extra_thickness);
            extrude_line(curve, bell_thickness + joint_clearance);
        }
//        polygon(curve[0]
    }
}


function bell_radius_at_height(curve, height) =
       [for (i = [1:1:len(curve)-1])
            if( curve[i-1][1] <= height && curve[i][1] >= height)
               curve[i][0]            
        ][0]
            ;
