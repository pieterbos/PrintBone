use <bessel.scad>

joint_extra_thickness = 1.2;
joint_length = 5; //length of the glue joint
joint_overlap = 3; //length that the joint sleeve overlaps the bell
default_joint_clearance = 0.13; //we need some joint clearance, obviously

joint_width = 6.5;
joint_depth = 9;
//for your joint to have a nice looking and printable bottom, set this higher
joint_slanted_bottom = 20;

lip_start=2;
lip_end=5;
lip_slant=1;
lip_length=7;


function inner_lip(joint_clearance=default_joint_clearance) = 
    [[lip_start+joint_clearance, 0], [lip_start+lip_slant +joint_clearance, lip_length-joint_clearance], [lip_end-lip_slant-joint_clearance, lip_length-joint_clearance], [lip_end-joint_clearance, 0]];

function lip() = 
    [[lip_start, 0], [lip_start+lip_slant, lip_length], [lip_end-lip_slant, lip_length], [lip_end, 0]];


/* render a joint at top of tube. rotate=true means the male part is up instead of down*/
module top_joint(polygon, rotate=false, joint_clearance=default_joint_clearance, solid=false) {
    
    difference() {
        translate(polygon[0]) {
            if(rotate) {
                union() {
                    polygon([[0, 0], [0, joint_slanted_bottom], [0, joint_depth], [joint_width, 0]]);
//                    polygon([[0, 0], [0, joint_slanted_bottom], [joint_width, joint_depth], [joint_width, 0]]);
                    rotate([0,180,180])
                    polygon(inner_lip());
                };
            } else {
                difference() {
                    polygon([[0, 0], [0, joint_slanted_bottom], [joint_width, joint_depth], [joint_width, 0]]);
                    if(!solid()) {
                        polygon(lip());
                    }
                };
            };
        };
        extrude_line(polygon, 0, true);
    };
}

/* render a joint at bottom of tube. rotate=true means the male part is up instead of down*/
module bottom_joint(polygon, rotate=false, joint_clearance=default_joint_clearance, solid=false) {
    difference() {
        translate(polygon[len(polygon)-1]) {
            if(rotate) {
                difference() {
                    rotate([0,180,180])
                    polygon([[0, 0], [0, joint_slanted_bottom], [joint_width, joint_depth], [joint_width, 0]]);
                rotate([0,180,180])
                    if(!solid) {
                      polygon(lip());
                    }
                }
            } else {
                union() {    
                  polygon([[0, 0], [0, -joint_slanted_bottom], [0, -joint_depth], [joint_width, 0]]);
                  polygon(inner_lip());
                }
  
            }
        };
        extrude_line(polygon, 0, solid=true);
    };
}

module flat_bottom_joint(full_curve, min_height, max_height, bell_thickness, joint_clearance=default_joint_clearance,) {
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