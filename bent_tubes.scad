use <scad-utils/transformations.scad>;
use <list-comprehension-demos/sweep.scad>;
use <array_iterator.scad>;

pi = 3.14159265359;

bent_tube(500, 10, 15, 150, 2.4, false, 50, 4);

/**
 * Render a bent tube with tube length 'length', radius at point 0 'radius1', radius at end 'radius2'
 * number of degrees to rotate 'degrees'. The radiuses as the inner diameters!
 * if solid, renders a solid rod, with radius radius1 + wall_thickness and radius2 + wall_thickness
 * if not, renders a tube with wall thickness wall_thickness. The wall_thickness will unfortunately scale with the same scale factor as the tube radius.
 * detail can be set with sweep_steps and circle_steps
 */
module bent_tube(length, radius1, radius2, degrees=180, wall_thickness=1.2, solid=false, sweep_steps = 25, circle_steps=4) {
    
    //the radius of the curve in the pipe, NOT of the tube diameters
    bend_radius = length/pi;
    //scale from first to second radius with transform function
    scale_increase = (radius2/radius1)-1;
    outer_scale_increase = ((radius2+wall_thickness)/(radius1+wall_thickness))-1;
        
    step = 0.5/sweep_steps;
    path = [for (t=array_iterator(0, step, (degrees)/360)) rotate_path(t, bend_radius)];
       
    //the solid rod with the smaller wall diameter needs to be slightly longer than the outer solid rod,
    //or the difference function will leave some polygons
    inner_tube_path = [for (t=array_iterator(-step*3, step, (degrees)/360 + step*3)) rotate_path(t, bend_radius)];   
        
    inner_tube_path_transform = construct_transform_path(inner_tube_path);
    path_transforms = construct_transform_path(path);
 
    if(!solid) {
        difference() {
            sweep(circle_points(radius1+ wall_thickness, circle_steps), scale_transform(path_transforms, outer_scale_increase));
            sweep(circle_points(radius1, circle_steps), scale_transform(inner_tube_path_transform, scale_increase));
        };
    } else {
        sweep(circle_points(radius1+ wall_thickness, circle_steps), scale_transform(path_transforms, outer_scale_increase));
    }    
}

function circle_points (radius=1, circle_steps) = [ for (a=array_iterator(0,circle_steps,360)) radius*[sin(a), cos(a)]];    

function rotate_path(t, radius) = [
    0,//tuning_slide_radius * cos(360 * t),
    radius * sin(360 * t),
    -radius * cos(360 * t)
];

function scale_transform(transform, scale_increase) = 
    [for (i=[0:1:len(transform)-1]) 
        transform[i] * scaling([1+scale_increase*i/len(transform),
        1+scale_increase*i/len(transform),
        1])//do not scale the length of the tuning slide
];

module tuning_slide_no_support(solid=false) {
    
    tuning_slide_bow(solid);
    tuning_slide_small_sleeve(solid);
    tuning_slide_large_sleeve(solid);
    
}