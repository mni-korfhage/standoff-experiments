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

module standoff_M3(x, y, height = 8, hole_depth = 6, hole_size = 3.9) {
    overall_diameter = 9;
    hole_depth = height-2;
    diameter_expansion = 1.085;
    x_y_ratio=1.03;
    standoff(x, y, height, overall_diameter, hole_size, hole_depth, diameter_expansion, x_y_ratio);
}