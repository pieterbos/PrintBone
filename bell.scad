use <array_iterator.scad>;

//curve library to generate the neckpipe. Not ideal, but works for now and much easier
//to create good tubes with than with sweep() like the tuning slide.
use <Curved_Pipe_Library_for_OpenSCAD/curvedPipe.scad>;


$fn = 300;
//tuning_slide(solid=false) module renders a tuning slide, using the sweep module.
include <tuning_slide.scad>;

$fn = 300;

//cut 3.5mm from the bell section. It'll be compensated, just a tad shorter tuning slide
//hack becuase i printed the bell too short :)
HACK_FOR_PRINTER=3.5;
bell_radius = 108.60;

slide_receiver_tolerance = -0.02;

connection_base_clearance = 0.15;

slide_receiver_small_radius = 50/pi/2 + slide_receiver_tolerance;
slide_receiver_large_radius = 54.7/pi/2 + slide_receiver_tolerance;

slide_receiver_sleeve_length=25;//normally 25

//extra width added to the slide receiver to match the slide


slide_receiver_length=31.5 + slide_receiver_tolerance;

// the thumb brace should be positioned for easy holding, so close to the slide
neckpipe_bell_connection_height = -330;

render_neckpipe_bases = true;

part = "bell_top";//bell_bottom;bell_middle;bell_top;tuning_slide;neckpipe_top;neckpipe_bottom;connection_bottom;connection_top; tube_connector_test_bottom;tube_connector_test_top;slide_receiver_test;tuning_slide_test;connection_test_one;connection_test_two

bell_thickness = 1.6;

bell_thickness_2 = 1.2;
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

neck_pipe_length = 269.10;
neck_pipe_radius = 7.25;

neckpipe_bell_connection_radius=6.5;

neck_pipe_minus_tuning_slide_receiver_length = neck_pipe_length - tuning_slide_small_length -tuning_sleeve_extra_length;

lip = [[lip_start, 0], [lip_start+lip_slant, lip_length], [lip_end-lip_slant, lip_length], [lip_end, 0]];

inner_lip = [[lip_start+lip_offset, 0], [lip_start+lip_slant +lip_offset, lip_length-lip_offset], [lip_end-lip_slant-lip_offset, lip_length-lip_offset], [lip_end-lip_offset, 0]];

total_bell_height = -55.93-96.85-150.42-150.42-53.36; //TODO: make this with proper parameters

echo(total_bell_height);

tuning_slide_large_receiver_inner_radius = tuning_slide_large_radius + tuning_slide_wall_thickness + tuning_slide_spacing;

//steps of the bessel curve for loop
steps=500;
    
    
first_bell_cut = -35;
second_bell_cut = -185;
third_bell_cut = second_bell_cut - 197+4;
fourth_bell_cut = third_bell_cut - 185;

//the curve (not really a polygon, just a set of points for now!) of the bell
bell_polygon = concat(
            //tuning slide receiver. Inner tuning slide radius: 9.9mm. That makes a wall thickness of
            //the tuning slide of 10.53 - 9.9!
            [
                [tuning_slide_large_receiver_inner_radius, -55.93-96.85-150.42-150.42-53.36-tuning_slide_large_length - tuning_sleeve_extra_length+HACK_FOR_PRINTER],
                [tuning_slide_large_receiver_inner_radius, -55.93-96.85-150.42-150.42-53.36]
            //[
            ],
             //this is equivalent to   conic_tube(h=53.36, r1=10.53, r2=11.05, wall=bell_thickness);
            [
                [11.05, -55.93-96.85-150.42-150.42], 
                [10.53, -55.93-96.85-150.42-150.42-53.36]
            ],
   
            2d_bessel_polygon(translation=-55.93-96.85-150.42,  throat_radius=11.05, mouth_radius=15.07, length=150.42, flare=1.260),
            2d_bessel_polygon(translation=-55.93-96.85, throat_radius=15.07, mouth_radius=22.28, length=150.42, flare=0.894),
        2d_bessel_polygon(translation=-55.93, throat_radius=22.28, mouth_radius=41.18, length=96.85, flare=0.494),
        2d_bessel_polygon(throat_radius=41.18, mouth_radius=bell_radius, length=55.93, flare=1.110)
    );

//TODO minor: the tuning slide of a real trombone is straight, then
//bends, then is straight again
//this makes this trombone too wide, which is a bit strange

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
        slide_receiver(bell_thickness);
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
        //tuning_slide();
    }

    //#check_slide_clearance(bell_thickness);
    if(part == "all" || part == "neckpipe_bottom") {
        bottom_part_of_neckpipe(bell_thickness);
    }
    if(part == "all" || part == "neckpipe_top") {
        top_part_of_neckpipe(bell_thickness);
    }
    if(part == "neckpipe") {        
        rotate([-90,0,0]) {
            neckpipe(bell_thickness);
            bell_side_neckpipe_bell_connection();
            tuning_slide_side_neckpipe_bell_connection();
        }
    }

    if(part == "test_1") {
        intersection() {
            translate([0, 500,-150])
            rotate([-90,0,0]) {
        top_part_of_neckpipe(bell_thickness);

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
            small_tuning_slide_sleeve(bell_thickness);
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
            solid_neckpipe(bell_thickness);
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
            solid_small_tuning_slide_sleeve(bell_thickness);
        } else {
            small_tuning_slide_sleeve(bell_thickness);
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

module connection_bases(tolerance=0.0) {
    neckpipe_connection_bases(tolerance);
    bell_connection_bases(tolerance);
    
}

module neckpipe_connection_bases(tolerance=0.0) {
    neckpipe_connection_base(19, -530, tolerance);
    neckpipe_connection_base(16, neckpipe_bell_connection_height, tolerance);
}

module neckpipe_connection_base(translation, height, tolerance) {
    difference() {
        translate([0,-tuning_slide_radius*2+translation, height-3])
        rotate([70,0,0])
        scale([1,1,1])
        cylinder(r2=6.3+tolerance, r1=3+tolerance, h=19, $fn=8);  
        neckpipe_implementation(bell_thickness, neck_pipe_radius, true);
    }
}

module bell_connection_bases(tolerance=0.0) {
    upper_bell_connection_base();
    lower_bell_connection_base();
}

module upper_bell_connection_base(tolerance=0.0) {
    bell_connection_base(-530, tolerance);
}

module lower_bell_connection_base(tolerance=0.0) {
    bell_connection_base(neckpipe_bell_connection_height, tolerance);
}    

module bell_connection_base(height, tolerance) {

    cylinder_height=15; 
    difference() {
        translate([0, -bell_radius_at_height(bell_polygon, height-4)-cylinder_height+5, height])
        rotate([-70,0,0])
        scale([1,1,1])
        cylinder(r2=8+tolerance, r1=1+tolerance, h=cylinder_height, $fn=4);  
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

    rotate_extrude()
    union() {
        extrude_line(polygon, bell_thickness_2);
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

function cut_curve(curve, min_height, max_height) = 
    cut_curve_at_height2( //bell_polygon,
        cut_curve_at_height(bell_polygon, min_height, max_height)
        , min_height, max_height);

module solid_bell() {
    rotate_extrude()   
    bell_profile();
}

module bell_profile() {
    extrude_solid(bell_polygon, bell_thickness_2);
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
        extrude_solid(polygon);
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
        extrude_solid(polygon);
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
            extrude_line(curve, bell_thickness_2 + joint_extra_thickness);
            extrude_line(curve, bell_thickness_2 + joint_clearance);
        }
//        polygon(curve[0]
    }
}


//bessel_curve(throat_radius=10.51, mouth_radius=108.06, length=-(-55.93-96.85-150.42-150.42), flare=0.78);
/* 
Renders a cone shaped tube.
wall is wall thickness
*/
module conic_tube(h, r1, r2, wall, center = false) {
  difference() {
          cylinder(h=h, r1=r1+wall, r2=r2+wall, center=center);
          cylinder(h=h, r1=r1, r2=r2, center=center);
  }
}

module conic_tube_conic_wall(h, r1, r2, wall1, wall2, center = false) {
  difference() {
          cylinder(h=h, r1=r1+wall2, r2=r2+wall1, center=center);
          cylinder(h=h, r1=r1, r2=r2, center=center);
  }
}

/*
* Bessel horn bell equation from
* http://www.acoustics.ed.ac.uk/wp-content/uploads/Theses/Braden_Alistair__PhDThesis_UniversityOfEdinburgh_2006.pdf
*/


module bessel_curve2(translation=0, throat_radius, mouth_radius, length, flare) {    

   2d_bessel = 2d_bessel_polygon(translation, throat_radius, mouth_radius, length, flare);

    extrude_line(2d_bessel, bell_thickness_2);   

}

module extrude_solid(curve) {
    polygon( points=
       concat(
        curve,
        [[0, 0]],
        [ [0, curve[0][1]]]
        )
    );
}

EPSILON = 0.00000001;
function abs_diff(o1, o2) =
    abs(o1-o2);
    
//from a single line, make a wall_thickness wide 2d polygon.
//translates along the normal vector without checking direction, so be careful :)
module extrude_line(input_curve, wall_thickness) {
    //remove consecutive points that are the same. Can't have that here or we'll have very strange results
    extrude_curve = concat([input_curve[0]], [for (i = [1:1:len(input_curve)-1]) if(abs_diff(input_curve[i][1], input_curve[i-1][1]) > EPSILON ) input_curve[i]]);

    polygon( points=
       concat(
        extrude_curve,
        
        [extrude_curve[len(extrude_curve)-1]+[wall_thickness, 0]],
        [for (i = [len(extrude_curve)-1:-1:1]) 
                extrude_curve[i] + 
                unit_normal_vector(
                    extrude_curve[i-1],
                    extrude_curve[i]
                )*wall_thickness
        ]
        //add the top most part, make sure it ends with a horizontal edge
        //so it can be joined to another surface if needed.
       ,[extrude_curve[0]+[wall_thickness, 0]]
        )
       
    );
}

//from a single line, make a cone outside line
//translates along the normal vector without checking direction, so be careful :)
module extrude_cone(input_curve, wall_thickness) {
    //remove consecutive points that are the same. Can't have that here or we'll have very strange results
    extrude_curve = concat([input_curve[0]], [for (i = [1:1:len(input_curve)-1]) if(abs_diff(input_curve[i][1], input_curve[i-1][1]) > EPSILON ) input_curve[i]]);

    polygon( points=
       concat(
        extrude_curve,
        [extrude_curve[len(extrude_curve)-1]+[wall_thickness, 0]],
        
        [for (i = [len(extrude_curve)-220:-1:1]) 
                extrude_curve[i] + 
                unit_normal_vector(
                    extrude_curve[i-1],
                    extrude_curve[i]
                )*wall_thickness
        ],
        //add the top most part, make sure it ends with a horizontal edge
        //so it can be joined to another surface if needed.
        [extrude_curve[0]+[wall_thickness,0]]
        )
       
    );
}

function 2d_bessel_polygon(translation=0, throat_radius, mouth_radius, length, flare) =    

    //inner curve of the bell
    let(
        b = bessel_b_parameter(throat_radius, mouth_radius, length, flare),
        x_zero = bessel_x_zero_parameter(throat_radius, b, flare),
        step_size = (length)/steps
    )

    [for (i = array_iterator(x_zero, step_size, x_zero + length)) 
         [bell_diameter(b, i, flare), i-(x_zero+length)] + [0, translation]
    ];


function bell_diameter(B, y, a) =
//   B/pow(y + y_zero,a);
   B*pow(-y,-a);
    
    
function bessel_b_parameter(r0, r1, d, gamma) =
    pow(
    (d/
        (
            pow(r0, -1/gamma) - 
            pow(r1, -1/gamma)
        )
    ), gamma);
 
function bessel_x_zero_parameter(r0, b, gamma) =
    - pow(r0/b, -1/gamma);
    
    
function unit_normal_vector(p1, p2) =
    let(
        dx = p2[0]-p1[0],
        dy = p2[1]-p1[1]
        ) 
        [dy, -dx]/norm([dy,-dx]);

function cut_curve_at_height(curve, min_height, max_height) =
    concat(
        [
            for (i = [0:1:len(curve)-2])
                if(curve[i+1][1] >= min_height)// && curve[i][1] <= max_height)
                   curve[i]             
        ],
        [for (i = [len(curve)-1]) if(curve[i][1] >= min_height) curve[i]]
    );
            
function cut_curve_at_height2(curve, min_height, max_height) =

    concat(
        [for (i = [0]) if(curve[i][1] <= max_height) curve[0]],
        [
        for (i = [1:1:len(curve)-1])
            if( curve[i][1] <= max_height)
               curve[i]             
        ]
    );

function bell_radius_at_height(curve, height) =
       [for (i = [1:1:len(curve)-1])
            if( curve[i-1][1] <= height && curve[i][1] >= height)
               curve[i][0]            
        ][0]
            ;
    
