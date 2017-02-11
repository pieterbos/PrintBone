/*
Module to render a bell based on multiple bessel curves
 To create a bessel curve:
 bessel_curve(throat_radius=10.51, mouth_radius=108.06, length=200, flare=0.78, wall_thickness=3)
 
 To create a bell profile, do the following:
Array of input. First element defines type:
["CYLINDER", radius, length]
["CONE", r1, r2, length]
["BESSEL", r_small, r_large, flare, length]

bell_input = [
    ["CYLINDER", 10/2, 40],
    ["CONE", 10.2/2, 10.3/2, 15],
    ["CONE", 10.3/2, 12.7/2, 44],
    ["BESSEL", 14.7/2, 23/2, 1.260, 223],
    ["BESSEL", 23/2, 37/2, 0.894, 72],
    ["BESSEL", 37/2, 61.8/2, 0.7, 36.6],
    ["BESSEL", 61.8/2, 8.5*25.4/2, 1, 14.37], 
];

bell_polygon = create_bell_profile(bell_input, steps=100);

rotate_extrude()
extrude_line(bell_polygon, wall_thickness=2, solid=false, normal_walls=true);
*/


use <array_iterator.scad>;
/*
#rotate_extrude()
bessel_curve(throat_radius=6.51, mouth_radius=94/2, length=400, flare=0.9, wall_thickness=3, solid=true, steps=100);

bell_input = [
    ["CYLINDER", 10.3/2, 40],
    ["CONE", 10.2/2, 10.3/2, 15],
    ["CONE", 10.3/2, 12.7/2, 44],
    ["BESSEL", 12.7/2, 23/2, 1.260, 223],
    ["BESSEL", 23/2, 37/2, 0.894, 72],
    ["BESSEL", 37/2, 61.8/2, 0.7, 36.6],
    ["BESSEL", 61.8/2, 94/2, 1, 14.37], 
];

bell_polygon = create_bell_profile(bell_input, steps=200);

rotate_extrude($fn=200)
extrude_line(bell_polygon, wall_thickness=2, solid=false);*/

function create_bell_profile(input, steps=100) =
    concat_array(
        [  
            for (i =[0:len(input)-1]) 
                translate_cylinder_input(input, i, steps)
        ]
    );

function concat_array(input, i=0) = 
    i >= len(input) ?
        [] :
        concat(input[i], concat_array(input, i+1));
            ;

// Haven't found a better way to define this in openscad. It works...
function translate_cylinder_input(input, i, steps) =
    let(value=input[i])
    value[0] == "CYLINDER" ?
            [
                [value[1], -sum_length(input, i)],
                [value[1], -sum_length(input, i+1)]
            ]
            : translate_cone_input(input, i, steps);
            ;

function translate_cone_input(input, i, steps) =
    let(value=input[i])
    value[0] == "CONE" ?
            [
                [value[1], -sum_length(input, i)],
                [value[2], -sum_length(input, i+1)]
            ]
            : translate_bessel_input(input, i, steps);
            ;

function translate_bessel_input(input, i, steps) =
    let(value=input[i])
    value[0] == "BESSEL" ?
//            [value[1], -sum_length(input, i)]
            2d_bessel_polygon(translation=sum_length(input, i+1),  throat_radius=value[1], mouth_radius=value[2], length=value[4], flare=value[3], steps=steps)
            : "ERROR";
            ;
     
// sum the length parameter of all input curves of point i and later. Length is always last
// input is array of instructions
function sum_length(input, i, sum = 0) =
    i >= len(input) ? sum : sum_length(input, i+1, sum + input[i][len(input[i])-1]);
    


function cut_curve(curve, min_height, max_height) = 
    cut_curve_at_height2( //bell_polygon,
        cut_curve_at_height(curve, min_height, max_height)
        , min_height, max_height);

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


module bessel_curve(translation=0, throat_radius, mouth_radius, length, flare, wall_thickness, solid=true, steps=100) {    

   2d_bessel = 2d_bessel_polygon(translation, throat_radius, mouth_radius, length, flare, steps);
   extrude_line(2d_bessel, wall_thickness, solid);

}

EPSILON = 0.00000000001;
function abs_diff(o1, o2) =
    abs(o1-o2);
    
//from a single line, make a wall_thickness wide 2d polygon.
//translates along the normal vector without checking direction, so be careful :)
module extrude_line(input_curve, wall_thickness, solid=false, remove_doubles=true, normal_walls=true) {
    //remove consecutive points that are the same. Can't have that here or we'll have very strange results

    extrude_curve = remove_doubles ? concat([input_curve[0]], [for (i = [1:1:len(input_curve)-1]) if(abs_diff(input_curve[i][1], input_curve[i-1][1]) > EPSILON || abs_diff(input_curve[i][0], input_curve[i-1][0]) > 0.001) input_curve[i]]) : input_curve;
        echo("walls normal?", normal_walls);
    outer_wall =  [for (i = [len(extrude_curve)-1:-1:1]) 
                    extrude_curve[i] + get_thickness_vector(normal_walls, wall_thickness, extrude_curve, i)
                    ];


    //make sure we have a horizontal edge both at the top and bottom
    //to ensure good printing and gluing possibilities
    bottom_point = [extrude_curve[len(extrude_curve)-1]+[wall_thickness, 0]];
    top_point = [extrude_curve[0]+[wall_thickness, 0]];

    outer_curve = concat(
            bottom_point,
            outer_wall,
            top_point
    );
    
    if(!solid) {
        // a bug in openscad causes small polygons with many points to render a MUCH lower resolution.

        scale([0.01, 0.01, 0.01])   
        polygon( points=
           concat(
            [ for (x=extrude_curve) [x[0]*100, x[1]*100]],
            [ for (x=outer_curve) [x[0]*100, x[1]*100]]
            )
        );
    } else {
        scale([0.01, 0.01, 0.01])
      polygon( points=
       concat(
          [[0, bottom_point[0][1]*100]],
          [ for (x=outer_curve) [x[0]*100, x[1]*100]],
          [[0, top_point[0][1]*100]]
        )
    );
    }
}

function get_thickness_vector (normal_walls, wall_thickness, extrude_curve, i) =
        let( normal_vector = unit_normal_vector(extrude_curve[i-1], extrude_curve[i]))
        (normal_walls) ? 
            normal_vector * wall_thickness 
        : (
                //horizontal walls need special treatment in this case
                normal_vector == [0,1] ? [0,-wall_thickness]:
                [wall_thickness, 0]
        );

function 2d_bessel_polygon(translation=0, throat_radius, mouth_radius, length, flare, steps=30) =    

    //inner curve of the bell
    let(
        b = bessel_b_parameter(throat_radius, mouth_radius, length, flare),
        x_zero = bessel_x_zero_parameter(throat_radius, b, flare),
        step_size = (length)/steps
    )

    [for (i = array_iterator(x_zero, step_size, x_zero + length)) 
         [bell_diameter(b, i, flare), -(i-(x_zero+length))] + [0, translation]
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
    
            
function radius_at_height(curve, height) =
        lookup(height, reverse_key_value(curve));
      /* [for (i = [1:1:len(curve)-1])
            if( curve[i-1][1] <= height && curve[i][1] >= height)
               curve[i][0]            
        ][0]
            ;*/
            
function reverse_key_value(array) = 
    [for (i = [1:1:len(array)-1])
        [-array[i][1], array[i][0]]
    ];

