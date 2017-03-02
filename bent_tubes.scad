use <scad-utils/transformations.scad>
use <list-comprehension-demos/skin.scad>

//the circle in shapes.scad is no good here, it stops one point too early
//causing a gap
function circle(r) = [for (i=[0:$fn]) let (a=i*360/$fn) r * [cos(a), sin(a)]];
function reverse(list) = [for (i = [0:len(list)-1]) list[len(list)-1-i]];


module tube(r1, r2, R, th, fn, degrees, solid)
{
    outer_r1 = r1+th;
    outer_r2 = r2 +th;
    if(solid) {
        skin([for(i=[0:fn]) 
          transform(rotation([0,degrees/fn*i,0])*translation([-R,0,0]), 
                circle(outer_r1+(outer_r2-outer_r1)/fn*i)        
        )]);
    } else {

        skin([for(i=[0:fn]) 
          transform(rotation([0,degrees/fn*i,0])*translation([-R,0,0]), 
            concat(
                circle(outer_r1+(outer_r2-outer_r1)/fn*i),
                reverse(circle(r1+(r2-r1)/fn*i))
            )
        )]);
    }
       

}
pi = 3.14159265359;
bent_tube(length=500, radius1=10, radius2=25, degrees=180, wall_thickness=2.4, 
    solid=false, sweep_steps=10, $fn=200);

/**
 * Render a bent tube with tube length 'length', radius at point 0 'radius1', radius at end 'radius2'
 * number of degrees to rotate 'degrees'. The radiuses as the inner diameters!
 * if solid, renders a solid rod, with radius radius1 + wall_thickness and radius2 + wall_thickness
 * if not, renders a tube with wall thickness wall_thickness. The wall_thickness will unfortunately scale with the same scale factor as the tube radius.
 * detail can be set with sweep_steps and circle_steps
 */
module bent_tube(length, radius1, radius2, degrees=180, wall_thickness=1.2, solid=false, sweep_steps = 25, method="hull") {
    
    //the radius of the curve in the pipe, NOT of the tube diameters
    bend_radius = length/pi;
    
    rotate([-90,-90,0])

        tube(r1=radius1, 
            r2=radius2, 
            degrees=degrees,
            fn=sweep_steps,
            R=bend_radius,
    
            th=wall_thickness,
            solid=solid
        );
}