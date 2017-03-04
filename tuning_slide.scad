use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>
//uncomment the following  lines to test just this file
/*
tuning_slide_length = 219.90;
tuning_slide_support_height=0.2;
pi = 3.14159265359;
tuning_slide_radius = tuning_slide_length/pi;
tuning_slide_small_length=67.32;
tuning_slide_large_length=67.32;
tuning_slide_small_radius = 7.55;
tuning_slide_large_radius = 9.9;

tuning_bow_wall_thickness = 1.2;
tuning_slide_wall_thickness = 0.8;

sweep_steps=20;
$fn=80;

//rotate([-90,0,0])
    tuning_slide(false);
//    tuning_slide_large_sleeve(solid);


transition_to_bow_height = 3;*/

inset_thickness=3;
module tuning_slide(solid = false) {
    union() {
        tuning_slide_no_support(solid);
        intersection() {
            difference() {
                rotate([0,90,0])
                    translate([0,0,-inset_thickness/2])
                    cylinder(r=tuning_slide_radius+4, h=inset_thickness);
                tuning_slide_bow(solid=true);
                translate([0,35.5-15/3-(tuning_slide_small_radius+tuning_slide_large_radius)/2,0])
                    rotate([90,0,0]) rotate([0,90,0])
                    cylinder(r=tuning_slide_radius-35.5, h=10, $fn=3, center=true);
                        
                    mirror_and_self([0,0,1]) {
                        translate([0,-tuning_slide_radius+2,-tuning_slide_radius])
                            rotate([0,90,0])
                            scale([0.7, 1.2, 1])
                                cylinder(r=tuning_slide_radius+1, h=4, center=true, $fn=4);
                    }
                  /*  translate([0,-tuning_slide_radius+2,tuning_slide_radius])
                        rotate([0,90,0])
                        scale([0.7, 1.2, 1])
                            cylinder(r=tuning_slide_radius, h=4, center=true, $fn=4);*/
                    translate([inset_thickness-0.3,-tuning_slide_radius+10,0])
                        rotate([90,0,0])
                        rotate([0,90,0])
                        linear_extrude(height=inset_thickness, center=true)
                        text("PrintBone", valign="center", $fn=40);

                     translate([-inset_thickness+0.3, 0])
                        rotate([90,0,0])
                        rotate([0,90,0])
                        mirror([1,0,0])
                        linear_extrude(height=inset_thickness, center=true)
                        text("PrintBone",valign="center", $fn=40);

            }
            translate([-10/2,1.2-(tuning_slide_radius+tuning_slide_small_length)/2,-tuning_slide_radius])
            cube([10,tuning_slide_radius+tuning_slide_small_length,tuning_slide_radius*2]);
        }

    }
}

module mirror_and_self(axis) {
    children(0);    
    rotate([-1.8,0,0]) //translate([0, tuning_slide_large_radius-tuning_slide_small_radius, 0])
    mirror(axis) children(0);
}

module tuning_slide_support_small() {
    difference() {
        translate([0, 0, -tuning_slide_radius-tuning_slide_small_radius*2+4]) {
            rotate([90,0,0]) {
                linear_extrude(height=tuning_slide_support_height) {
                    square([tuning_slide_small_radius, tuning_slide_small_radius*2], center=true);                        
                }
            }
        };
        tuning_slide_bow(solid=true);
    }
}

module tuning_slide_support_large() {
    difference() {
        translate([0, 0, tuning_slide_radius+tuning_slide_large_radius*2-4]) {
            rotate([90,0,0]) {
                linear_extrude(height=tuning_slide_support_height) {
                    square([tuning_slide_small_radius, tuning_slide_small_radius*2], center=true);                        
                }
            }
        };
        tuning_slide_no_support(solid=true);
    }
}


module tuning_slide_no_support(solid=false) {
    tuning_slide_bow(solid);
}

module tuning_slide_bow(solid=false) {
     rotate([-90, -90, 0])
    difference() {
        tube(R=tuning_slide_radius,
            r1=tuning_slide_small_radius, 
            r2=tuning_slide_large_radius, 
            r_peg_1=tuning_slide_small_radius,
            r_peg_2=tuning_slide_large_radius, 
            peg_th=tuning_slide_wall_thickness, 
            peg_length=tuning_slide_small_length, 
            degrees=180, 
            th=tuning_bow_wall_thickness, 
            solid=true, 
            fn=sweep_steps,
            render_bump=true);
        if(!solid) {
            tube(R=tuning_slide_radius,
                r1=tuning_slide_small_radius, 
                r2=tuning_slide_large_radius, 
                r_peg_1=tuning_slide_small_radius,
                r_peg_2=tuning_slide_large_radius, 
                peg_th=0, 
                peg_length=tuning_slide_small_length, 
                degrees=180, 
                th=0, 
                solid=true, 
                fn=sweep_steps);
        }
    }
   // bent_tube(tuning_slide_length, tuning_slide_small_radius, tuning_slide_large_radius, 180, tuning_bow_wall_thickness, solid, sweep_steps);
}



//the circle in shapes.scad is no good here, it stops one point too early
//causing a gap
function circle(r) = [
    for (i=[0:$fn]) 
        let (a=i*360/$fn) 
        r * [cos(a), sin(a)]
    ];
    
bump_angle_1 = 25;
bump_angle_2 = 335;
bump_height = 3;
bump_divisor = bump_angle_1/bump_height;
function circle_with_bump(r) = [
    for (i=[0:$fn]) 
        let (a=i*360/$fn) 
        r * [cos(a), sin(a)] + (a <= bump_angle_1 || a >= bump_angle_2 ? [min(a >= bump_angle_2 ? abs(a-bump_angle_2-1)/bump_divisor : (bump_angle_1+1-a)/bump_divisor, bump_height-1), 0]: [0, 0])
    ];
    
function circle_with_hole(r_outer, r_inner) = 
    concat ( 
        circle(r_outer), reverse(circle(r_inner))
    );

function reverse(list) = [for (i = [0:len(list)-1]) list[len(list)-1-i]];


module tube(r1, r2, r_peg_1, r_peg_2, peg_th, peg_length, R, th, fn, degrees, render_bump)
{
    outer_r1 = r1+th;
    outer_r2 = r2 +th;
    
    outer_peg_1_r = r_peg_1 + peg_th;
    outer_peg_2_r = r_peg_2 + peg_th;
   skin(
        concat(
            //peg 1
            [
                transform(translation([-R,0,-peg_length-transition_to_bow_height]), circle(outer_peg_1_r)),
                transform(translation([-R,0, -transition_to_bow_height]), circle(outer_peg_1_r))
            ],
            //bow
            [for(i=[0:fn]) 
            transform(rotation([0,i*degrees/fn,0])*translation([-R,0,0]), 
                concat(
                render_bump ? circle_with_bump(outer_r1+(outer_r2-outer_r1)/fn*i) :
                    circle(outer_r1+(outer_r2-outer_r1)/fn*i)
                )
            )],
            
            //peg 2
            [
                transform(rotation([0,degrees,0])*translation([-R,0, transition_to_bow_height]), circle(outer_peg_2_r)),
                transform(rotation([0,degrees,0])*translation([-R,0,peg_length+transition_to_bow_height]), circle(outer_peg_2_r))
            ]
      )
    );

       

}
