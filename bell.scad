//curve library to generate the neckpipe. Not ideal, but works for now and much easier
//to create good tubes with than with sweep() like the tuning slide.
//TODO: replace with the library newly written for this project, bent_tubes :)
use <Curved_Pipe_Library_for_OpenSCAD/curvedPipe.scad>;

use <bessel.scad>;
use <connections.scad>;

$fn = 20;
//tuning_slide(solid=false) module renders a tuning slide, using the sweep module.
include <tuning_slide.scad>;



//TUNING SLIDE PARAMETERS
//difference between outer diameter of tuning slide and inner diameter of sleeve in mm
tuning_slide_spacing = 0.1;
//the receiver can be slightly longer than the slide
tuning_sleeve_extra_length = 0;
tuning_slide_large_receiver_inner_radius = tuning_slide_large_radius + tuning_slide_wall_thickness + tuning_slide_spacing;

//DETAIL PARAMETERS
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to a few hundred
steps=50;
//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 20;

//the radius of the bell in mm
bell_radius = 108.60; 

bell_input = [

    ["CYLINDER", tuning_slide_large_receiver_inner_radius, tuning_slide_large_length+tuning_sleeve_extra_length],
    ["CONE", 10.53, 11.05, 53.36],
    ["BESSEL", 11.05, 15.07, 1.260, 150.42],
    ["BESSEL", 15.07, 22.28, 0.894, 150.42],
    ["BESSEL", 22.28, 41.18, 0.494, 96.85],
    ["BESSEL", 41.18, bell_radius, 1.110, 55.93]
];

//where the bell should be cut for printing
first_bell_cut = -35;
second_bell_cut = -195;
third_bell_cut = second_bell_cut - 195;
fourth_bell_cut = third_bell_cut - 185;

//thumb brace height. Higher thumb brace = more negative number, sorry bout that
// the thumb brace should be positioned for easy holding, so close to the slide
neckpipe_bell_connection_height = -330;


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

part = "all";//bell_bottom;bell_middle;bell_top;tuning_slide;neckpipe_top;neckpipe_bottom;connection_bottom;connection_top; tube_connector_test_bottom;tube_connector_test_top;slide_receiver_test;tuning_slide_test;connection_test_one;connection_test_two

//WALL THICKNESSES
//the wall thickness of the neckpipe. A value between 0.8 and 1.6 should be fine, depending on your nozzle and slicer
neckpipe_wall_thickness = 1.6;
//the wall thickness of the bell. For 8.5 inch, 1.6 works great. For tiny bells, 1.2 is enough.
bell_wall_thickness = 1.6;





neck_pipe_length = 269.10;
neck_pipe_radius = 7.25;


neckpipe_bell_connection_radius=6.5;

neck_pipe_minus_tuning_slide_receiver_length = neck_pipe_length - tuning_slide_small_length -tuning_sleeve_extra_length;


total_bell_height = -55.93-96.85-150.42-150.42-53.36; //TODO: make this with proper parameters

echo(total_bell_height);





//the curve (not really a polygon, just a set of points for now!) of the bell
bell_profile = create_bell_profile(bell_input, steps);

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
            render_bell_segment(render_bottom_lip=true, render_top_lip=false, min_height=fourth_bell_cut, max_height=third_bell_cut);
            upper_bell_connection_base();
        }
    }
    
    if(part == "all" || part == "bell_middle_2") {
        union() {
            render_bell_segment(render_bottom_lip=true, render_top_lip=true, min_height=third_bell_cut, max_height=second_bell_cut);
          lower_bell_connection_base();
        }
    }
    if(part == "all" || part == "bell_middle") {
        render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=second_bell_cut, max_height=first_bell_cut,render_flat_bottom_lip=true);
          //TODO: move
    }
    if(part == "all" || part == "bell_bottom_2") {
        intersection() {
            render_bell_bottom();
            translate([-120,-120,-200])
            cube([210, 250, 200]);
        }
    }
    
    if(part == "all" || part == "bell_bottom_1") {

        intersection() {
            render_bell_bottom();
            translate([-120+210,-120,-200])
            cube([210, 250, 200]);
        }
    }
    
    if(part == "bell_bottom") {

        intersection() {
            render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=-190, max_height=0);
            translate([80,-120,-200])
            cube([200, 250, 200]);
        }
    }


    //two part bell - for very high printers!
    /*union() {
        render_bell_segment(render_bottom_lip=true, render_top_lip=false, min_height=-580, max_height=-290);
        bell_connection_bases();
    }*/
    //render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=-290, max_height=0);


    if(part == "all") {
//        translated_tuning_slide();
    }
    if(part == "tuning_slide") {
        tuning_slide();
    }

    //#check_slide_clearance(neckpipe_wall_thickness);
    if(part == "all" || part == "neckpipe_bottom") {
        bottom_part_of_neckpipe(neckpipe_wall_thickness);
    }
    if(part == "all" || part == "neckpipe_top") {
        top_part_of_neckpipe(neckpipe_wall_thickness);
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
    

    if(part == "all" || part == "connection_bottom") {
        bell_side_neckpipe_bell_connection();
    }
    if(part == "all" || part == "connection_top") {
        tuning_slide_side_neckpipe_bell_connection();
    }
}

module render_bell_bottom() {
    
    extra_height  = 0.87; //TODO: get exact height from bell_profile
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
        difference() {
            cylinder(r=slide_receiver_large_radius + wall_thickness+edge_for_locknut_thickness, h=edge_for_locknut_length);
            cylinder(r=slide_receiver_large_radius + wall_thickness, h=edge_for_locknut_length);
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
            solid_neckpipe(neckpipe_wall_thickness);
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
    connection_bases();
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
    neckpipe_connection_base(19, -530, clearance);
    neckpipe_connection_base(16, neckpipe_bell_connection_height, clearance);
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
    bell_connection_base(-530, clearance);
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
            top_joint(polygon);                
        };
        if(render_bottom_lip) {
            bottom_joint(polygon); 
        }            
        if (render_flat_bottom_lip) {
            flat_bottom_joint(bell_profile, min_height, max_height, bell_wall_thickness);
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
