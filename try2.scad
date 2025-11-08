base_x = 40;
base_y = 14;
base_thickness = 1;

// Make the hole eliptical to compensate for the way it prints.

module hole(diameter, height, along_across_ratio = 1.05) {
    linear_extrude(height)
        scale([1, along_across_ratio]) 
            circle(d = diameter, $fa=1, $fs=0.5);
}

module standoff(x, y, height, diameter, hole_diameter, hole_depth) {
    translate([x, y, 0]) difference() {
        cylinder(h=height, d=diameter);
        translate([0, 0, height-hole_depth]) 
            hole(hole_diameter*1.08);
//            cylinder(h=hole_depth+.01, d=hole_diameter, $fa=1, $fs=0.5);
    }
}

standoff_y = 8;
standoff_h = 8;
hole_depth = 6;
text_height = 1;
text_base = base_thickness - 0.1;

union() {
    cube([base_x, base_y, base_thickness]);
    standoff(5, standoff_y, standoff_h, 6, 3, hole_depth);
    translate([1, 0.2, text_base]) linear_extrude(text_height) text("3mm", 3);
    standoff(15, standoff_y, standoff_h, 7, 3.5, hole_depth);
    translate([12.5, 0.2, text_base]) linear_extrude(text_height) text("3.5", 3);
    standoff(25, standoff_y, standoff_h, 8, 4, hole_depth);
    translate([22.5, 0.2, text_base]) linear_extrude(text_height) text("4", 3);
    standoff(35, standoff_y, standoff_h, 8.5, 4.5, hole_depth);
    translate([32.5, 0.2, text_base]) linear_extrude(text_height) text("4.5", 3);
    translate([26.5, 1, text_base]) linear_extrude(text_height) text("PLA", 2);}