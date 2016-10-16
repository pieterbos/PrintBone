/*
Module to render bessel curves, specifically for a trombone bell
 To use: 
 bessel_curve(throat_radius=10.51, mouth_radius=108.06, length=200, flare=0.78, wall_thickness=3)
*/

use <array_iterator.scad>;

rotate_extrude()
bessel_curve(throat_radius=10.51, mouth_radius=108.06, length=-(-55.93-96.85-150.42-150.42), flare=0.78, wall_thickness=3, solid=false);


function cut_curve(curve, min_height, max_height) = 
    cut_curve_at_height2( //bell_polygon,
        cut_curve_at_height(bell_polygon, min_height, max_height)
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


module bessel_curve(translation=0, throat_radius, mouth_radius, length, flare, wall_thickness, solid=true) {    

   2d_bessel = 2d_bessel_polygon(translation, throat_radius, mouth_radius, length, flare);
   extrude_line(2d_bessel, wall_thickness, solid);

}

EPSILON = 0.00000001;
function abs_diff(o1, o2) =
    abs(o1-o2);
    
//from a single line, make a wall_thickness wide 2d polygon.
//translates along the normal vector without checking direction, so be careful :)
module extrude_line(input_curve, wall_thickness, solid=false) {
    //remove consecutive points that are the same. Can't have that here or we'll have very strange results
    extrude_curve = concat([input_curve[0]], [for (i = [1:1:len(input_curve)-1]) if(abs_diff(input_curve[i][1], input_curve[i-1][1]) > EPSILON ) input_curve[i]]);

    outer_wall =  [for (i = [len(extrude_curve)-1:-1:1]) 
                extrude_curve[i] + 
                unit_normal_vector(
                    extrude_curve[i-1],
                    extrude_curve[i]
                )*wall_thickness
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
        polygon( points=
           concat(
            extrude_curve,
            outer_curve
            )
           
        );
    } else {
      polygon( points=
       concat(
        [[0, 0]],
        outer_curve,
        [ [0, outer_curve[len(outer_curve)-1][1]]]
        )
    );
    }
}

function 2d_bessel_polygon(translation=0, throat_radius, mouth_radius, length, flare, steps=100) =    

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
            ;
    
