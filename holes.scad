
module hole(diameter, depth, along_across_ratio = 1.025) {
    linear_extrude(depth+0.1)
        scale([1, along_across_ratio]) 
            circle(d = diameter, $fa=1, $fs=0.5);
}


module hole_M2(x, y, thickness, hole_diameter = 2.3) {
    translate([x, y, 0])
        cylinder(thickness + epsilon * 2, d = hole_diameter, true, $fa=1, $fs=0.5);
}


module hole_M3(x, y, thickness, hole_diameter = 3.2) {
    translate([x, y, 0])
        cylinder(thickness + epsilon * 2, d = hole_diameter, true, $fa=1, $fs=0.5);
}

module hole_M4(x, y, thickness, hole_diameter = 4.5) {
    translate([x, y, 0])
        cylinder(thickness + epsilon * 2, d = hole_diameter, true, $fa=1, $fs=0.5);
}

module hole(x, y, thickness, hole_diameter) {
    translate([x, y, 0])
        cylinder(thickness + epsilon * 2, d = hole_diameter, true, $fa=1, $fs=0.5);
}