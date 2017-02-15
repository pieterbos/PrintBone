use <bessel.scad>;

//CONSTANTS
pi = 3.14159265359;

//WALL THICKNESSES
//the wall thickness of the bell. For 8.5 inch, 1.6 works great. For tiny bells, 1.2 is enough.
bell_wall_thickness = 1.2;

/* [DETAIL PARAMETERS] */
//steps for all rotate_extrude calls. For development: 20 is enough. For printing set to 300
$fn = 300;
//steps of the bessel curve for loop. Increases bell detail.
//for development 50 is enought, for printing set to 100-150
steps=100;

mute_base_radius=25;


/* [BELL PARAMETERS]*/
//the mute, as a series of bessel curves
mute_input = [
    ["BESSEL", 25, 49, 0.6, 108],
    ["BESSEL", 49, 25, -0.6, 40]
];

//the thickness of the cork used, for visualization
render_cork = false;
cork_thickness = 1.6;

//the height of the tapered area that fits the bell. It's the outside shape only
tapered_area_height = 20;

//the curve (not yet a polygon, just a set of points on a line for now!) of the mute
bell_profile = create_bell_profile(mute_input, steps);

//it's possible to render a bell profile of a trombone to check the fit of the mute.
// This is the printbone, but you can render any trombone you want of course
render_bell_profile = true;

//the diameters of the tube used to mute
hole_diameter_top = 3.8;
//and the smallest part
hole_diameter_small=3.5;
//and the largest part at the bottom of the mute
hole_diameter_bottom = 4.6;

bell_input = [
//part of the printbone, for reference
    ["BESSEL", 15.07, 22.28, 0.894, 150.42],
    ["BESSEL", 22.28, 41.18, 0.494, 96.85],
    ["BESSEL", 41.18, 8.5*25.4/2, 1.110, 55.93]
];
bell_height = sum_length(mute_input, 0);
bell_profile_full = create_bell_profile(bell_input, 50);


cork_bessel = [
    ["BESSEL", bell_profile[0][0], bell_profile[0][0]+3.55, 0.6, tapered_area_height],
    ["CONE", bell_profile[0][0]+3.55, bell_radius_at_height(bell_profile, bell_height-tapered_area_height-2.2), 2.2]
];

cork_profile = create_bell_profile(cork_bessel, 50);

render_bell_profile=false;

if(render_bell_profile) {
    translate([0, 0, 39])
rotate([90,0,0])
//rotate_extrude()
    extrude_line(input_curve=bell_profile_full, wall_thickness=bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=true);
}

letter_height=52;
second_line_height=48;
letter_rotation=-21;
translate([0,0,letter_height])
    rotate([0,0,0])
    writeOnMute(
        text="PrintBone", 
        radius=radius_at_height(bell_profile, letter_height)+bell_wall_thickness-0.4, 
        letter_rotation=letter_rotation,
        h=8.5);
/*translate([0,0,second_line_height])
    rotate([0,0,0])
    writeOnMute(
        text="Practice Mute", 
        radius=radius_at_height(bell_profile, second_line_height, h=1)+bell_wall_thickness-0.5,
        letter_rotation=letter_rotation-4,
        h=6,
east=2, font="Arial"
    );*/

module writeOnMute(text,radius,letter_rotation, h=5, t=1, east=0, west=0, space =1.0, font){
    bold=0;
	center=false;
	rotate=0;			// text rotation (clockwise)

    pi2=pi*2;
    up =0;		 //mm up from center on face of cube
	down=0;
    
	wid=(.125* h *5.5 * space);
	widall=wid*(text_width(text, 0, len(text)-1))/2; 
	//angle that measures width of letters on sphere
	function NAngle(radius)=(wid/(pi2*radius))*360*(1-abs(rotate)/90);
	//angle of half width of text

	function mmangle(radius)=(widall/(pi2*radius)*360);
			translate([0,0,up-down])
			rotate(east-west,[0,0,1])
			for (r=[0:len(text)-1]){
				rotate(-90+(text_width(text, 0, r)*NAngle(radius)),[0,0,1])
				translate([radius,0,-r*((rotate)/90*wid)+(text_width(text, 0, len(text)-1))/2*((rotate)/90*wid)])
                rotate([0,letter_rotation,0])
				rotate(90,[1,0,0])
				rotate(93.5,[0,1,0])
                linear_extrude(height=t)
                text(text[r], center=true, size=h, font=font);
		//echo("zloc=",height/2-r*((rotate)/90*wid)+(len(text)-1)/2*((rotate)/90*wid));
			}

}
//the text/write module does not provide spacing or kerning data
//so here it is for the default font. Set to 1 for monospaced fonts for all letters :)
font_spacing_data = [
["a", 1.15],
["b", 1.12],
["c", 1.1],
["d", 1],
["e", 1.2],
["f", 1],
["g", 1],
["h", 1],
["i", 0.55],
["j", 0.7],
["k", 1],
["l", 0.6],
["m", 1.75],
["n", 1.2],
["o", 1.17],
["p", 1.15],
["q", 1],
["r", 0.83],
["s", 1.1],
["t", 0.8],
["u", 1.3],
["v", 1],
["w", 1],
["x", 1],
["y", 1],
["z", 1],
["A", 1.4],
["B", 1.4],
["C", 1.4],
["D", 1.4],
["E", 1.4],
["F", 1.4],
["G", 1.4],
["H", 1.4],
["I", 1.4],
["J", 1.4],
["K", 1.4],
["L", 1.4],
["M", 1.8],
["N", 1.4],
["O", 1.4],
["P", 1.45],
["Q", 1.4],
["R", 1.4],
["S", 1.4],
["T", 1.3],
["U", 1.3],
["V", 1.3],
["W", 1.3],
["X", 1.3],
["Y", 1.3],
["Z", 1.3],
[" ", 0.8]
];

function text_width(string, index, max_len) =
    max_len == 0 ? 0 :
    (index >= max_len-1 ? 
        text_width_one_letter(string, index) : 
        text_width_one_letter(string, index) + text_width(string, index+1, max_len));

function text_width_one_letter(string, index) =
    font_spacing_data[search(string[index], font_spacing_data)[0]][1];
    

rotate_extrude()
union(){
    extrude_line(bell_profile, bell_wall_thickness, solid=false, remove_doubles=true, normal_walls=false);
    muting_tube();
    //bottom
    mute_bottom();
    difference() {
        cork_profile();    
        solid_mute_profile();
    }

}   

//render the cork to test fit
if(render_cork) {
    %rotate_extrude()
    difference() {
        cork_profile(bell_wall_thickness+cork_thickness);
    solid_mute_profile();
   }
}



module mute_bottom(){
    radius_at_top_of_bottom = bell_radius_at_height(bell_profile, bell_wall_thickness)+bell_wall_thickness;
    radius_a_bit_higher = bell_radius_at_height(bell_profile, bell_wall_thickness*2.5)+bell_wall_thickness;
    polygon(points=[[hole_diameter_bottom,0], [25,0],
        [radius_a_bit_higher, bell_wall_thickness*2.5],
        [radius_at_top_of_bottom-4, bell_wall_thickness], 
//[radius_at_top_of_bottom, bell_wall_thickness], 
        [hole_diameter_bottom, bell_wall_thickness]]);
}

module muting_tube() {
    tube_outside_radius = hole_diameter_top+bell_wall_thickness*1.5;
    polygon([
        //bottom edge of tube
        [hole_diameter_bottom, 0], [tube_outside_radius+bell_wall_thickness*2, 0], 
        [tube_outside_radius, 5], 
        //top edge of tube
        [tube_outside_radius, 40], [hole_diameter_top, 40],
        //and slightly smaller part near bottom
        [hole_diameter_top, 6], [hole_diameter_small, 2]
   ]);
}

module cork_profile(thickness=bell_wall_thickness) {
    translate([0, bell_height-sum_length(cork_bessel, 0)])
        //rotate_extrude()
        extrude_line(input_curve=cork_profile, wall_thickness=thickness, solid=true, remove_doubles=true, normal_walls=false);
}

module solid_mute_profile() {
    extrude_line(bell_profile, bell_wall_thickness, solid=true, normall_walls=false);
}

function bell_radius_at_height(curve, height) =
    radius_at_height( curve, height);