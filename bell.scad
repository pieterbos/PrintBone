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
bell_profile = create_bell_profile(bell_input, steps);

//ECHO THE BELL PROFILE
//for(t= [0:len(bell_profile)-1]) {
//    echo(str(2790+bell_profile[t][1],",",bell_profile[t][0]*2,";"));
//}

//the height of the bell minus tuning slide receiver length
//TODO: get rid of the 'minus tuning slide receiver length?
total_bell_height = -sum_length(bell_input, 0); 

neckpipe_cut_height_calculated = total_bell_height + neck_pipe_length - neckpipe_cut_height;
echo(top_neckpipe_bell_connection_height - neckpipe_cut_height_calculated, "test");

top_neckpipe_bell_connection_height=neckpipe_cut_height_calculated-neckpipe_bell_connection_radius;
neckpipe_bell_connection_height = top_neckpipe_bell_connection_height+neckpipe_cut_height;
echo(neckpipe_bell_connection_height);

echo("total bell height", total_bell_height);
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
            if(bell_bottom_fits_on_plate) {
                render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=first_bell_cut, max_height=0);
                if(render_bell_support) {
                    bell_support();
                }
            } else {
                intersection() {
                    render_bell_segment(render_bottom_lip=false, render_top_lip=true, min_height=first_bell_cut, max_height=0);                    
                    translate([-120,-120,-200])
                    cube([210, 250, 200]);
                }
                if(render_bell_support) {
                    bell_support();
                }
            }
        }
    }

    if(part == "all") {
        translated_tuning_slide();
    }
    if(part == "tuning_slide") {
        tuning_slide( $fn = tuning_slide_fn);
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
        tuning_slide($fn=tuning_slide_fn);
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

    translate([0,-tuning_slide_radius, total_bell_height]) {//total_bell_height-tuning_slide_small_length]) {
        rotate([270,0,0]) {
            tuning_slide($fn=tuning_slide_fn);
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
            solid_bell_segment(height-30, height+30);



            bell_connection_bases(connection_base_clearance, difference_with_bell=false);//speed up rendering by making this part very simple
           if(!render_neckpipe_bell_connection_with_neckpipe) {
               neckpipe_connection_bases(connection_base_clearance);
           }

       }        


}

module bottom_part_of_neckpipe(wall_thickness) {
    intersection() {
        translate([-50, -tuning_slide_radius*2-50, neckpipe_cut_height_calculated])
        cube(neckpipe_cut_height);
           neckpipe(wall_thickness);
    }
    translate([0, -tuning_slide_radius*2, neckpipe_cut_height_calculated])
    rotate_extrude()
    
    top_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true);
}


module top_part_of_neckpipe(wall_thickness) {
    intersection() {
        translate([-50, -tuning_slide_radius*2-50,  neckpipe_cut_height_calculated-neckpipe_cut_height])
        cube(neckpipe_cut_height);
                   neckpipe(wall_thickness);
    }
    bottom_joint_height=10;
    translate([0, -tuning_slide_radius*2, neckpipe_cut_height_calculated -bottom_joint_height])
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
    translate([0, -tuning_slide_radius*2, neckpipe_cut_height_calculated -bottom_joint_height])
    rotate_extrude()    
    bottom_joint([[neck_pipe_radius,0], [neck_pipe_radius, 10]], rotate=true, joint_clearance, solid=true);
}

module neckpipe_implementation(wall_thickness, neck_pipe_radius, solid=false, check_slide_clearance=false) {


        small_tuning_slide_sleeve(neckpipe_wall_thickness, solid);


        od = neck_pipe_radius*2 + wall_thickness+2;
        id = solid? 0.0005 : neck_pipe_radius*2;

            
        goose_neck_offset = 4;

        goose_neck_start = 75;

        slide_receiver_begin = neck_pipe_minus_tuning_slide_receiver_length -slide_receiver_length;

        goose_neck_x_length = slide_receiver_begin - goose_neck_start;
        goose_neck_y_length = goose_neck_offset;


        goose_neck_angle=atan(goose_neck_y_length/goose_neck_x_length);

        //neck pipe, including gooseneck
        //LOOK HERE
        translate([0, -tuning_slide_radius *2, total_bell_height + tuning_slide_small_length + tuning_sleeve_extra_length])
            curvedPipe([ [0,0,0],
				[0,0,goose_neck_start],
				[0,-goose_neck_offset,slide_receiver_begin]				
			   ],
	            2, //two segments. strange library
				[50],
                od,
                id);
    
        //slide receiver
        translate([0, -tuning_slide_radius *2-goose_neck_offset, total_bell_height + tuning_slide_small_length+ tuning_sleeve_extra_length + slide_receiver_begin])
        rotate([goose_neck_angle, 0, 0])
        slide_receiver(wall_thickness, solid);
    

    
    if(check_slide_clearance) {
        translate([0, -tuning_slide_radius *2-goose_neck_offset, total_bell_height + tuning_slide_small_length + tuning_sleeve_extra_length + slide_receiver_begin])    
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

module bell_connection_bases(clearance=0.0, difference_with_bell=true) {
    upper_bell_connection_base(clearance, difference_with_bell);
    lower_bell_connection_base(clearance, difference_with_bell);
}

module upper_bell_connection_base(clearance=0.0, difference_with_bell=true) {
    bell_connection_base(top_neckpipe_bell_connection_height, clearance, difference_with_bell);
}

module lower_bell_connection_base(clearance=0.0, difference_with_bell=true) {
    bell_connection_base(neckpipe_bell_connection_height, clearance, difference_with_bell);
}    

module bell_connection_base(height, clearance, difference_with_bell=true) {

    cylinder_height=15; 
    difference() {
        translate([0, -radius_at_height(bell_profile, height-4)-cylinder_height+5, height])
        rotate([-70,0,0])
        scale([1,1,1])
        cylinder(r2=8+clearance, r1=1+clearance, h=cylinder_height, $fn=4);  
//        solid_bell();
        if(difference_with_bell) {
            solid_bell_segment(height-cylinder_height/2, height+cylinder_height);
        }
    }
}

module small_tuning_slide_sleeve(wall_thickness, solid=false) {
    translate([0, -tuning_slide_radius *2, total_bell_height])
    difference() {
        cylinder(h = tuning_slide_small_length + tuning_sleeve_extra_length, r = tuning_slide_small_radius + tuning_slide_wall_thickness + tuning_slide_spacing + wall_thickness);
        if(!solid) {
            cylinder(h = tuning_slide_small_length + tuning_sleeve_extra_length, r =    tuning_slide_small_radius + tuning_slide_wall_thickness + tuning_slide_spacing);
        }
    };
    
    translate([0, -tuning_slide_radius *2, total_bell_height+tuning_slide_small_length])
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

module solid_bell_segment(min_height, max_height) {
    polygon = cut_curve(bell_profile, min_height, max_height);  
    rotate_extrude()   
        extrude_line(polygon, bell_wall_thickness, solid=true);
}

//custom support rendering for bell bottom
use <scad-utils/lists.scad>;

//a partial circle, from begin to end. 0 to 1 means a full circle
function circle_points(r, begin, end) = [
    for (i=[0:$fn]) 
        let (a=begin + i*(end-begin)/$fn) 
        r * [cos(a*360), sin(a*360)]
    ];

    
    
support_thickness=0.42;

function zigzag(outer_radius, inner_radius, extra=0, step=0.02) = flatten(
    [for(i=[0:step:1])
        concat(
            circle_points(outer_radius, i+extra, i+step/2-extra, $fn=1),
            circle_points(inner_radius, i+step/2-extra, i+step+extra, $fn=1)
        )
    ]
);

//polygon(test);


smaller_bell_profile = concat([for(i=[0:len(bell_profile)]) bell_profile[i] + [0,0.1]],
    bell_profile[len(bell_profile)-1] //include the first 0.1mm as well :)
);

module smaller_solid_bell_segment(smaller_bell_profile, min_height, max_height) {
  //  polygon = cut_curve(smaller_bell_profile, min_height, max_height);  
    rotate_extrude()   
        extrude_line(smaller_bell_profile, 0, solid=true);//0 means no wall thickness - it's the inside profile we want here
}
//    rotate([0,180, 0])
//smaller_solid_bell_segment(smaller_bell_profile, -900, 100);
module bell_support_part(outer_radius, inner_radius, step) {

    intersection() {
       rotate([0,180,0])
        linear_extrude(height=50) {
            polygon(concat(zigzag(outer_radius, inner_radius, 0, step), 
            zigzag(outer_radius-support_thickness, 
                inner_radius - support_thickness, 
                support_thickness/(outer_radius*2*PI), 
                step)));
        }
        smaller_solid_bell_segment(smaller_bell_profile, -900, 100);

    }
}

module bell_support() {
    bell_support_part(bell_radius, bell_radius-15, step=0.015);
    bell_support_part(bell_radius-15-0.5, bell_radius-30, step=0.02);
}
