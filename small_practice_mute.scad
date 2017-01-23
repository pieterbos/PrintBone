//CONSTANTS
pi = 3.14159265359;



/* [TUNING SLIDE PARAMETERS] */
// the length of the tube of the tuning slide. You usually not change this for a regular Bb trombone :)
tuning_slide_length = 219.90; // [50:350]
// the length of the small diameter tube of the tuning slide
tuning_slide_small_length=67.32;
// the length of the large diameter tube of the tuning slide
tuning_slide_large_length=67.32;
// the radius of the small diameter tube of the tuning slide
tuning_slide_small_radius = 7.55;
// the radius of the large diameter tube of the tuning slide
tuning_slide_large_radius = 9.9;

// the wall thickness of the tuning slide
tuning_bow_wall_thickness = 1.2;
// the wall thickness of the tuning slide tubes that go into the trombone
tuning_slide_wall_thickness = 0.8;

/* [DETAIL PARAMETERS] */
//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 360;
//determines the level of detail of the tuning slide. Higher = higher quality
//set to something like 100 for a smooth tuning slide
sweep_steps = 20;
//determines the level of detail of the tuning slide tube. Lower = higher quality
//set to 1 for a really smooth tuning slide and LONG rendering time
tuning_slide_step_length_in_degrees = 4;
//set to 300 for when you want to print
tuning_slide_fn=20;
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to a few hundred
steps=100;

//the tuning slide will be rendered with two small squares under which you can print support
//this makes the model more stable, making printing much easier.
//the height determines the ease of removal. 0.2 works well
tuning_slide_support_height=0.2;

/* TUNING SLIDE RECEIVER PARAMETERS */
//difference between outer diameter of tuning slide and inner diameter of sleeve in mm
tuning_slide_spacing = 0.1;
//the receiver can be slightly longer than the slide
tuning_sleeve_extra_length = 0;
tuning_slide_large_receiver_inner_radius = tuning_slide_large_radius + tuning_slide_wall_thickness + tuning_slide_spacing;

// tuning slide radius, do not set this parameter, it is calculated based on length
tuning_slide_radius = tuning_slide_length/pi;



/* [BELL PARAMETERS]*/
//the radius of the bell in mm
bell_radius = 108.60; 

bell_input = [
    ["CONE", 20, 25, 6],
    ["BESSEL", 25, 47, 0.6, 100],

    ["CONE", 47, 49, 8],

    ["BESSEL", 49, 20, -0.4, 20]
];

//render the bottom-most part of the bell flare as a separate piece
//this can making printing the bell without support easier
//if you set this to true, you will have to uncomment a line in generate_trombone.sh as well
//see that file for more details
render_bell_flare_in_two_pieces = false;
two_part_cut_height = -35;
//where the bell should be cut for printing
first_bell_cut = -195;
second_bell_cut = first_bell_cut - 195;
third_bell_cut = second_bell_cut - 195;

//thumb brace height. Higher thumb brace = more negative number, sorry bout that
// the thumb brace should be positioned for easy holding, so close to the slide
//TODO: just calculate this based on the neckpipe cut length
neckpipe_bell_connection_height = -311.18;
top_neckpipe_bell_connection_height=-486.49;


//CLEARANCES
/* clearance for the slide receiver. Increase for a looser fit*/
slide_receiver_clearance = -0.02;
/* clearance for the connectors on the braces between bell and neckpipe. Increase for looser fit */
connection_base_clearance = 0.15;
//The clearances of the glue joints
joint_clearance = 0.1;


//SLIDE RECEIVER
//the smallest radius of the slide receiver. Measure this on your slide.
slide_receiver_small_radius = 50/pi/2 + slide_receiver_clearance;
//the larges radius of the slide receiver. Measure this on your slide.
slide_receiver_large_radius = 54.7/pi/2 + slide_receiver_clearance;
//The slide receiver length. Measure on your slide.
slide_receiver_length=31.5 + slide_receiver_clearance;

//defines the slope. the connection between the neckpipe and the slide receiver
//mainly for visual improvement.
//play around until you get a good looking result. The default is usually fine.
slide_receiver_sleeve_length=25;


//which part to render.
part = "mute";//bell_bottom;bell_middle;bell_top;tuning_slide;neckpipe_top;neckpipe_bottom;connection_bottom;connection_top; tube_connector_test_bottom;tube_connector_test_top;slide_receiver_test;tuning_slide_test;connection_test_one;connection_test_two

//WALL THICKNESSES
//the wall thickness of the neckpipe. A value between 0.8 and 1.6 should be fine, depending on your nozzle and slicer
neckpipe_wall_thickness = 1.6;
//the wall thickness of the bell. For 8.5 inch, 1.6 works great. For tiny bells, 1.2 is enough.
bell_wall_thickness = 1.2;

//NECKPIPE
neck_pipe_length = 269.10;
neck_pipe_radius = 7.25; //inner radius of the neckpipe

//the braces between neckpipe and bell radius.
neckpipe_bell_connection_radius=6.5;
//whether to render the braces with the neckpipe, or as separate parts. Rendering with the neckpipe
// is great if you want the braces to be exactly where the connectors of the neckpipe are - easy printing, less glueing.
//if you don't want that, set this to false
render_neckpipe_bell_connection_with_neckpipe=true;
//neckpipe will usually be longer than you can print in one go
//the length after which at which it will be cut
neckpipe_cut_height=190;


neck_pipe_minus_tuning_slide_receiver_length = neck_pipe_length - tuning_slide_small_length -tuning_sleeve_extra_length;


//DO NOT RUN THIS SCRIPT, IT WILL GENERATE ERRORS!
//instead open one of the models in the sub-folders, for example large_tenor. This script will be called from there

//curve library to generate the neckpipe. Not ideal, but works for now and much easier
//to create good tubes with than with sweep() like the tuning slide.
//TODO: replace with the library newly written for this project, bent_tubes :)
use <Curved_Pipe_Library_for_OpenSCAD/curvedPipe.scad>;

use <bessel.scad>;
use <connections.scad>;


include <tuning_slide.scad>;

//the curve (not really a polygon, just a set of points for now!) of the bell
bell_profile2 = create_bell_profile(bell_input, steps);
bell_profile = concat(bell_profile2, [[20,0], [5,-0.0001], [4.7, -4], [5, -6], [5,-60]]);
echo(bell_profile);

//the height of the bell minus tuning slide receiver length
//TODO: get rid of the 'minus tuning slide receiver length?
total_bell_height = -sum_length(bell_input, 1); 

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
        slide_receiver(neckpipe_wall_thickness);
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
            render_bell_segment(render_bottom_lip=true, render_top_lip=false, min_height=third_bell_cut, max_height=second_bell_cut);
            upper_bell_connection_base();
        }
    }
    if(part == "all" || part == "bell_middle") {
        render_bell_segment(render_bottom_lip=true, render_top_lip=true, min_height=second_bell_cut, max_height=first_bell_cut,render_flat_bottom_lip=false);
          lower_bell_connection_base();
    }
    if(part == "all" || part == "bell_bottom_1") {
        intersection() {
            render_bell_bottom(two_part_cut_height);
            translate([-120+210,-120,-200])
            cube([210, 250, 200]);
        }
    }
    
    if(render_bell_flare_in_two_pieces) {
        if(part == "all" || part == "bell_bottom") {
            intersection() {
                render_bell_bottom(two_part_cut_height);
                translate([-120,-120,-200])
                cube([210, 250, 200]);
            }
        }
        if(part == "all" || part == "bell_bottom_top_part") {
            intersection() {
                render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=first_bell_cut, max_height=two_part_cut_height,render_flat_bottom_lip=true);
                translate([-120,-120,-200])
                cube([210, 250, 200]);
            }
        }
        
    } else {    
        if(part == "all" || part == "bell_bottom") {
            intersection() {
                render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=first_bell_cut, max_height=0);
                translate([-120,-120,-200])
                cube([210, 250, 200]);
            }
        }
    }

    if(part == "mute") {
        
      render_bell_segment(render_bottom_lip=false, render_top_lip=false, min_height=-200, max_height=0);

        
    }
    if(part == "all") {
        translated_tuning_slide();
    }
    if(part == "tuning_slide") {
        old_fn = $fn;
        $fn = tuning_slide_fn;
        tuning_slide();
        $fn = old_fn;
    }

    //#check_slide_clearance(neckpipe_wall_thickness);
    if(part == "all" || part == "neckpipe_bottom") {
        bottom_part_of_neckpipe(neckpipe_wall_thickness);
        if(render_neckpipe_bell_connection_with_neckpipe) {
            bell_side_neckpipe_bell_connection();
        }
    }
    if(part == "all" || part == "neckpipe_top") {
        top_part_of_neckpipe(neckpipe_wall_thickness);
        if(render_neckpipe_bell_connection_with_neckpipe) {
            tuning_slide_side_neckpipe_bell_connection();
        }
    }
    if(part == "neckpipe") {        
        rotate([-90,0,0]) {
            neckpipe(neckpipe_wall_thickness);
            bell_side_neckpipe_bell_connection();
            tuning_slide_side_neckpipe_bell_connection();
        }
    }

    if(part == "test_1") {
        intersection() {
            translate([0, 500,-150])
            rotate([-90,0,0]) {
        top_part_of_neckpipe(neckpipe_wall_thickness);

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
    
    if(!render_neckpipe_bell_connection_with_neckpipe) {
        if(part == "all" || part == "connection_bottom") {
            bell_side_neckpipe_bell_connection();
        }
        if(part == "all" || part == "connection_top") {
            tuning_slide_side_neckpipe_bell_connection();
        }
    }
}


module render_bell_bottom(height) {
   
    union() {
        render_bell_segment(render_bottom_lip=false, render_top_lip=false, min_height=height, max_height=0);
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
            small_tuning_slide_sleeve(neckpipe_wall_thickness);
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
    old_fn = $fn;
    $fn=tuning_slide_fn;    
    translate([0,-tuning_slide_radius,total_bell_height-tuning_slide_small_length]) {
        rotate([270,0,0]) {
            tuning_slide();
        }
    };
    $fn = old_fn;
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


        edge_for_locknut_length= 2.5;
        outer_edge_for_locknut_length = solid ? edge_for_locknut_length +10: edge_for_locknut_length;
    edge_for_locknut_thickness = 1.5;
        translate([0,0,slide_receiver_length-edge_for_locknut_length])
        difference() {
            cylinder(r=slide_receiver_large_radius + wall_thickness+edge_for_locknut_thickness, h=outer_edge_for_locknut_length);
            cylinder(r=slide_receiver_large_radius + wall_thickness, h=edge_for_locknut_length);
        }
        if(solid) {
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
    neckpipe_bell_connection(top_neckpipe_bell_connection_height);

}

module neckpipe_bell_connection(height) {


        difference() {
            translate([0,0,height])
            rotate([90,0,0])
            cylinder(h = tuning_slide_radius*2, r=neckpipe_bell_connection_radius);
            solid_neckpipe(neckpipe_wall_thickness);
            solid_bell();

            connection_bases(connection_base_clearance);
        }        
     


}

module bottom_part_of_neckpipe(wall_thickness) {
    intersection() {
        translate([-50, -tuning_slide_radius*2-50, -480])
        cube(neckpipe_cut_height);
           neckpipe(wall_thickness);
    }
    translate([0, -tuning_slide_radius*2, -480])
    rotate_extrude()
    
    top_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true);
}


module top_part_of_neckpipe(wall_thickness) {
    intersection() {
        translate([-50, -tuning_slide_radius*2-50, -670])
        cube(neckpipe_cut_height);
                   neckpipe(wall_thickness);
    }
    bottom_joint_height=10;
    translate([0, -tuning_slide_radius*2, -670+neckpipe_cut_height-bottom_joint_height])
    rotate_extrude()
    
    bottom_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true, joint_clearance,solid=false);
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
        bottom_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true, joint_clearance, solid=true);
    connection_bases();
    bottom_joint_height=10;
    translate([0, -tuning_slide_radius*2, -670+neckpipe_cut_height-bottom_joint_height])
    rotate_extrude()    
    bottom_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true, joint_clearance, solid=true);
}

module neckpipe_implementation(wall_thickness, neck_pipe_radius, solid=false, check_slide_clearance=false) {

        if(solid) {
            solid_small_tuning_slide_sleeve(neckpipe_wall_thickness);
        } else {
            small_tuning_slide_sleeve(neckpipe_wall_thickness);
        }

        od = neck_pipe_radius*2 + wall_thickness+2;
        id = solid? 0.0005 : neck_pipe_radius*2;

            
        goose_neck_offset = 4;

        goose_neck_start = 75;

        slide_receiver_begin = neck_pipe_minus_tuning_slide_receiver_length -slide_receiver_length;

        goose_neck_x_length = slide_receiver_begin - goose_neck_start;
        goose_neck_y_length = goose_neck_offset;


        goose_neck_angle=atan(goose_neck_y_length/goose_neck_x_length);

        //neck pipe, including gooseneck
        translate([0, -tuning_slide_radius *2, total_bell_height + tuning_sleeve_extra_length])
            curvedPipe([ [0,0,0],
				[0,0,goose_neck_start],
				[0,-goose_neck_offset,slide_receiver_begin]				
			   ],
	            2, //two segments. strange library
				[50],
                od,
                id);
    
        //slide receiver
        translate([0, -tuning_slide_radius *2-goose_neck_offset, total_bell_height + tuning_sleeve_extra_length + slide_receiver_begin])
        rotate([goose_neck_angle, 0, 0])
        slide_receiver(wall_thickness, solid);
    

    
    if(check_slide_clearance) {
        translate([0, -tuning_slide_radius *2-goose_neck_offset, total_bell_height + tuning_sleeve_extra_length + slide_receiver_begin])    
            rotate([goose_neck_angle, 0, 0])
            cylinder(r=5, h=730);

    }
}

module connection_bases(clearance=0.0) {
    neckpipe_connection_bases(clearance);
    bell_connection_bases(clearance);
    
}

module neckpipe_connection_bases(clearance=0.0) {
    if(!render_neckpipe_bell_connection_with_neckpipe) {
        neckpipe_connection_base(19, top_neckpipe_bell_connection_height, clearance);
        neckpipe_connection_base(16, neckpipe_bell_connection_height, clearance);
    }

}

module neckpipe_connection_base(translation, height, clearance) {
    difference() {
        translate([0,-tuning_slide_radius*2+translation, height-3])
        rotate([70,0,0])
        scale([1,1,1])
        cylinder(r2=6.3+clearance, r1=3+clearance, h=19, $fn=8);  
        neckpipe_implementation(neckpipe_wall_thickness, neck_pipe_radius, true);
    }
}

module bell_connection_bases(clearance=0.0) {
    upper_bell_connection_base(clearance);
    lower_bell_connection_base(clearance);
}

module upper_bell_connection_base(clearance=0.0) {
    bell_connection_base(top_neckpipe_bell_connection_height, clearance);
}

module lower_bell_connection_base(clearance=0.0) {
    bell_connection_base(neckpipe_bell_connection_height, clearance);
}    

module bell_connection_base(height, clearance) {

    cylinder_height=15; 
    difference() {
        translate([0, -bell_radius_at_height(bell_profile, height-4)-cylinder_height+5, height])
        rotate([-70,0,0])
        scale([1,1,1])
        cylinder(r2=8+clearance, r1=1+clearance, h=cylinder_height, $fn=4);  
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
        cylinder(h=20, r2=neck_pipe_radius+wall_thickness, r1=tuning_slide_small_radius + +tuning_slide_wall_thickness + tuning_slide_spacing + wall_thickness);
        if(!solid) {
            cylinder(h=20, r=neck_pipe_radius);
        }
    }
}

module solid_small_tuning_slide_sleeve(wall_thickness) {
    small_tuning_slide_sleeve(wall_thickness, solid=true);
}

module render_bell_segment(render_bottom_lip, render_top_lip, min_height, max_height, render_flat_bottom_lip=false) {
    
    polygon = cut_curve(bell_profile, min_height, max_height);   

    echo("start and end of polygon: " );
    echo(polygon[0]);
        echo(polygon[len(polygon)-1]);

    rotate_extrude()
    union() {
        extrude_line(polygon, bell_wall_thickness, solid=false);
        if(render_top_lip) {
            top_joint(polygon, joint_clearance);                
        };
        if(render_bottom_lip) {
            bottom_joint(polygon, joint_clearance); 
        }            
        if (render_flat_bottom_lip) {
            flat_bottom_joint(bell_profile, min_height, max_height, bell_wall_thickness, joint_clearance);
        } 
    }
}

module solid_bell() {
    rotate_extrude()   
    solid_bell_profile();
}

module solid_bell_profile() {
    extrude_line(bell_profile, bell_wall_thickness, solid=true);
}

function bell_radius_at_height(curve, height) =
       [for (i = [1:1:len(curve)-1])
            if( curve[i-1][1] <= height && curve[i][1] >= height)
               curve[i][0]            
        ][0]
            ;
