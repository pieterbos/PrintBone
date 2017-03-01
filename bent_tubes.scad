pi = 3.14159265359;
bent_tube(length=500, radius1=10, radius2=15, degrees=180, wall_thickness=2.4, 
    solid=false, sweep_steps=10, $fn=64);

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
    
    rotate([0,90,0])
    difference() {
        rod(r1=radius1+wall_thickness, 
            r2=radius2+wall_thickness, 
            angle=degrees,
            steps=sweep_steps,
            bow_radius=bend_radius
        );
        if(!solid) {
            rod(r1=radius1, 
                r2=radius2, 
                extra_angle=degrees/sweep_steps+5,
                angle=degrees,
                steps=sweep_steps,
                bow_radius=bend_radius
            );
        }
    }

}

module rod(r1=10, r2=15, extra_angle=0, angle=180, wall_thickness=1.6, steps=10, bow_radius=100) {
    stepsize = angle/steps;
    angle_step = (r2/r1-1)/angle;
    if(extra_angle > stepsize) {
        for(t = [-extra_angle:stepsize: 0-stepsize]) {
            hull() {
                rod_segment(t, bow_radius, angle_step, r1);
                rod_segment(t+stepsize, bow_radius, angle_step, r1);
            }
        }
    }
    for(t = [0:stepsize:angle-stepsize+extra_angle]) {
        hull() {
            rod_segment(t, bow_radius, angle_step, r1);
            rod_segment(t+stepsize, bow_radius, angle_step, r1);
        }
    }
}

module rod_segment(t, bow_radius, angle_stepsize, r1) {
    rotate([90,0,t])
        translate([bow_radius, 0,0])
        scale([1+t*angle_stepsize,1+t*angle_stepsize,1])
        cylinder(height=0.0000001, r=r1, center=true);
}