base_x = 25;
base_y = 20;
base_thickness = 1;

// Make the hole eliptical to compensate for the way it prints.

module hole(diameter, depth, along_across_ratio = 1.025) {
    linear_extrude(depth+0.1)
        scale([1, along_across_ratio]) 
            circle(d = diameter, $fa=1, $fs=0.5);
}

module standoff(x, y, height, diameter, hole_diameter, hole_depth, diameter_expansion = 1.08, x_y_ratio) {
    translate([x, y, 0]) difference() {
        cylinder(h=height, d=diameter);
        translate([0, 0, height-hole_depth]) 
            hole(hole_diameter*diameter_expansion, hole_depth, x_y_ratio);
//            cylinder(h=hole_depth+.01, d=hole_diameter, $fa=1, $fs=0.5);
    }
}

module standoff_M25(x, y, height = 8, hole_depth = 6) {
    overall_diameter = 7.5;
    hole_size = 3.1;
    hole_depth = height-2;
    diameter_expansion = 1.105;
    x_y_ratio=1.08;
    standoff(x, y, height, overall_diameter, hole_size, hole_depth, diameter_expansion, x_y_ratio);
}

module standoff_M3(x, y, height = 8, hole_depth = 6) {
    overall_diameter = 9;
    hole_size = 3.9;
    hole_depth = height-2;
    diameter_expansion = 1.085;
    x_y_ratio=1.03;
    standoff(x, y, height, overall_diameter, hole_size, hole_depth, diameter_expansion, x_y_ratio);
}

standoff_y = 14;
standoff_h = 8;
//hole_depth = 6;
text_height = 1;
text_base = base_thickness - 0.1;

union() {
    cube([base_x, base_y, base_thickness]);
    standoff_M25(5, standoff_y, standoff_h);
///     standoff(5, standoff_y, standoff_h, 7.5, 3.1, hole_depth, diameter_expansion = 1.105, x_y_ratio=1.08);
    translate([1, 1, text_base]) linear_extrude(text_height) text("3.1", 5, font="Arial:style=Bold");
    
    standoff_M3(15, standoff_y, standoff_h);
    
///    standoff(15, standoff_y, standoff_h, 9, 3.9, hole_depth, diameter_expansion = 1.085, x_y_ratio=1.03);
    translate([12.5, 1, text_base]) linear_extrude(text_height) text("3.9", 5, font="Gil Sans Ultra Bold");
    
    rotate(90) translate([7, -24.4, text_base]) linear_extrude(text_height) text("#8", 4.5, font="Arial:style=Bold");
}