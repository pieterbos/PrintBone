use <bent_tubes.scad>;

slide_crook_tube_length=150;
slide_crook_radius=7.5;//15 mm diameter for now
slide_crook_wall_thickness=1.2;

pi = 3.14;//TODO
slide_crook_length=slide_crook_tube_length/pi;

sweep_steps=25;
circle_steps=1;

outer_slide_grip_radius=6.5;
inner_slide_grip_radius=outer_slide_grip_radius;

slide_tube_length=700;

//the distance between hand grip and end of inner slide

hand_grip_distance = 25;
oversleeve_length=75;

slide_crook_sleeve_length=50;

outer_slide_tube_radius=7.5;
inner_slide_tube_radius=6.5;
oversleeve_wall_thickness=2.0;
oversleeve_radius = outer_slide_tube_radius + oversleeve_wall_thickness;

slide_crook_sleeve_radius=outer_slide_tube_radius+2;

#outer_slide_tube_1();
#outer_slide_tube_2();
#inner_slide_tube_1();
#inner_slide_tube_2();
slide_crook();

outer_slide_grip();
inner_slide_grip();


module outer_slide_grip() {
    difference() {
        translate([0, -slide_tube_length + hand_grip_distance, -slide_crook_length])
        cylinder(r=outer_slide_grip_radius, h=slide_crook_length*2);
        outer_slide_tube_1();
        outer_slide_tube_2();
    };
    
    difference() {
        oversleeves();
        outer_slide_tube_1();
        outer_slide_tube_2();
    }
}
module oversleeves() {
    translate([0,-slide_tube_length+oversleeve_length,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=oversleeve_radius, h=oversleeve_length);


    translate([0,-slide_tube_length+oversleeve_length,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=oversleeve_radius, h=oversleeve_length);    
}


module slide_crook() {
    bent_tube(length=slide_crook_tube_length,
        radius1=slide_crook_radius, 
        radius2=slide_crook_radius,
        degrees=180,
        wall_thickness=slide_crook_wall_thickness,
        solid=false, 
        sweep_steps = sweep_steps, circle_steps=circle_steps);

    slide_crook_sleeve_1();
    slide_crook_sleeve_2();
}

module slide_crook_sleeve_1() {
    difference() {
        translate([0,0,slide_crook_length])
        rotate([90,0,0])
        cylinder(r=slide_crook_sleeve_radius, h=slide_crook_sleeve_length);
        outer_slide_tube_1();
    }
}


module slide_crook_sleeve_2() {
    difference() {
        translate([0,0,-slide_crook_length])
        rotate([90,0,0])
        cylinder(r=slide_crook_sleeve_radius, h=slide_crook_sleeve_length);
        outer_slide_tube_2();
    }
}
    
    
module outer_slide_tube_1() {
    translate([0,0,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=outer_slide_tube_radius, h=slide_tube_length+2);
}

module outer_slide_tube_2() {
    translate([0,0,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=outer_slide_tube_radius, h=slide_tube_length+2);
}


module inner_slide_tube_1() {
    translate([100,0,slide_crook_length])
    rotate([90,0,0])
    cylinder(r=inner_slide_tube_radius, h=slide_tube_length+2);
}

module inner_slide_tube_2() {
    translate([100,0,-slide_crook_length])
    rotate([90,0,0])
    cylinder(r=inner_slide_tube_radius, h=slide_tube_length+2);
}

module inner_slide_grip() {
    difference() {
        translate([100, -slide_tube_length + hand_grip_distance, -slide_crook_length])
        cylinder(r=outer_slide_grip_radius, h=slide_crook_length*2);
        inner_slide_tube_1();
        inner_slide_tube_2();
    };
    //TODO: these should consist of two parts:
    //    1. A part in which the slide gets glued
    //    2. A part in which the slide goes when in first position
    difference() {
        translate([100,0,0])
        oversleeves();
        inner_slide_tube_1();
        inner_slide_tube_2();
    }
}


    

