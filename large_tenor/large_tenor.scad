//CONSTANTS
pi = 3.14159265359;

//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 20;

//TUNING SLIDE PARAMETERS
tuning_slide_length = 219.90;
tuning_slide_small_length=67.32;
tuning_slide_large_length=67.32;
tuning_slide_small_radius = 7.55;
tuning_slide_large_radius = 9.9;

tuning_bow_wall_thickness = 1.2;
tuning_slide_wall_thickness = 0.8;

//TUNING SLIDE DETAIL PARAMETERS
//determines the level of detail of the tuning slide. Higher = higher quality
//set to something like 100 for a smooth tuning slide
sweep_steps = 20;
//determines the level of detail of the tuning slide tube. Lower = higher quality
//set to 1 for a really smooth tuning slide and LONG rendering time
tuning_slide_step_length_in_degrees = 4;
//set to 300 for when you want to print
tuning_slide_fn=20;

//the tuning slide will be rendered with two small squares under which you can print support
//this makes the model more stable, making printing much easier.
//the height determines the ease of removal. 0.2 works well
tuning_slide_support_height=0.2;

//TUNING SLIDE RECEIVER PARAMETERS
//difference between outer diameter of tuning slide and inner diameter of sleeve in mm
tuning_slide_spacing = 0.1;
//the receiver can be slightly longer than the slide
tuning_sleeve_extra_length = 0;
tuning_slide_large_receiver_inner_radius = tuning_slide_large_radius + tuning_slide_wall_thickness + tuning_slide_spacing;


tuning_slide_radius = tuning_slide_length/pi;

//DETAIL PARAMETERS
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to a few hundred
steps=50;


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


//which part to render.
part = "all";//bell_bottom;bell_middle;bell_top;tuning_slide;neckpipe_top;neckpipe_bottom;connection_bottom;connection_top; tube_connector_test_bottom;tube_connector_test_top;slide_receiver_test;tuning_slide_test;connection_test_one;connection_test_two

//WALL THICKNESSES
//the wall thickness of the neckpipe. A value between 0.8 and 1.6 should be fine, depending on your nozzle and slicer
neckpipe_wall_thickness = 1.6;
//the wall thickness of the bell. For 8.5 inch, 1.6 works great. For tiny bells, 1.2 is enough.
bell_wall_thickness = 1.6;

//NECKPIPE
neck_pipe_length = 269.10;
neck_pipe_radius = 7.25; //inner radius of the neckpipe

neckpipe_bell_connection_radius=6.5;

neck_pipe_minus_tuning_slide_receiver_length = neck_pipe_length - tuning_slide_small_length -tuning_sleeve_extra_length;


include <../bell.scad>;
