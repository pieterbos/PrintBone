//CONSTANTS
pi = 3.14159265359;



/* [TUNING SLIDE PARAMETERS] */
// the length of the tube of the tuning slide. You usually not change this for a regular Bb trombone :)
tuning_slide_length = 219.90; // [50:350]
// the length of the small diameter tube of the tuning slide
tuning_slide_small_length=48;
// the length of the large diameter tube of the tuning slide
tuning_slide_large_length=48;
// the radius of the small diameter tube of the tuning slide
tuning_slide_small_radius = 5.5;//unknown, but let's guess 11mm
// the radius of the large diameter tube of the tuning slide
tuning_slide_large_radius = 13.5/2;

//you probably won't need to change this
bump_angle_1 = 25;
bump_angle_2 = 335;
bump_height = 3;
bump_divisor = bump_angle_1/bump_height;
transition_to_bow_height = 3;


// the wall thickness of the tuning slide
tuning_bow_wall_thickness = 1.6;
// the wall thickness of the tuning slide tubes that go into the trombone
tuning_slide_wall_thickness = 0.8;

/* [DETAIL PARAMETERS] */
//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 300;
//determines the level of detail of the tuning slide. Higher = higher quality
//set to something like 100 for a smooth tuning slide
sweep_steps = 100;
//set to 300 for when you want to print
tuning_slide_fn=300;
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to a few hundred
steps=100;

//the tuning slide will be rendered with two small squares under which you can print support
//this makes the model more stable, making printing much easier.
//the height determines the ease of removal. 0.2 works well
tuning_slide_support_height=0.2;

/* TUNING SLIDE RECEIVER PARAMETERS */
//difference between outer diameter of tuning slide and inner diameter of sleeve in mm
tuning_slide_spacing = 0.08;
//the receiver can be slightly longer than the slide
tuning_sleeve_extra_length = 0;
tuning_slide_large_receiver_inner_radius = tuning_slide_large_radius + tuning_slide_wall_thickness + tuning_slide_spacing;

// tuning slide radius, do not set this parameter, it is calculated based on length
tuning_slide_radius = (tuning_slide_length-2*transition_to_bow_height)/pi;



/* [BELL PARAMETERS]*/
//the radius of the bell in mm
bell_radius = 102; 

//A Schnitzer, 1594, Edinburgh university collection, Edinburgh)
bell_input = [

    ["CYLINDER", tuning_slide_large_receiver_inner_radius, tuning_slide_large_length+tuning_sleeve_extra_length],
//    ["CONE", 10.53, 11.05, 53.36],
    ["BESSEL", 13.7/2, 15/2, 1.260, 76],
    ["BESSEL", 15/2, 18/2, 1.260, 100],
    ["BESSEL", 18/2, 23.5/2, 1.260, 100],
    ["BESSEL", 23.5/2, 30.5/2, 0.9, 100],
    ["BESSEL", 30.5/2, 38.5/2, 0.4, 50],
    ["BESSEL", 38.5/2, 57/2, 1.2, 50],
    ["BESSEL", 57/2, 73/2, 1.4, 25],
    ["BESSEL", 73/2, bell_radius/2, 0.85, 25],
//    ["BESSEL", 38.5/2, bell_radius/2, 1.1, 100]
];



//render the bottom-most part of the bell flare as a separate piece
//this can making printing the bell without support easier
//if you set this to true, you will have to uncomment a line in generate_trombone.sh as well
//see that file for more details
render_bell_flare_in_two_pieces = false;
bell_bottom_fits_on_plate=true;
two_part_cut_height = -35;
//where the bell should be cut for printing
first_bell_cut = -193;
second_bell_cut = first_bell_cut - 193;
third_bell_cut = second_bell_cut - 195;


//CLEARANCES
/* clearance for the slide receiver. Increase for a looser fit*/
slide_receiver_clearance = 0.05;
/* clearance for the connectors on the braces between bell and neckpipe. Increase for looser fit */
connection_base_clearance = 0.15;
//The clearances of the glue joints
joint_clearance = 0.1;


//SLIDE RECEIVER
//TODO: measure small bore horn and put in correct data here
//the smallest radius of the slide receiver. Measure this on your slide.
slide_receiver_small_radius = 14.0/2;
//the larges radius of the slide receiver. Measure this on your slide.
slide_receiver_large_radius = 15.1/2;//54.7/pi/2 + slide_receiver_clearance;
//The slide receiver length. Measure on your slide.
slide_receiver_length=23.3 + slide_receiver_clearance;

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
neck_pipe_radius = tuning_slide_small_radius; //inner radius of the neckpipe. unko

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
render_bell_support=false;

include <../bell.scad>;
