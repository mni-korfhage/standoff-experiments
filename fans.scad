module fan_30mm(x, y, thickness) {
    fan_diameter = 28.5;
    mounting_hole_offset = 12;
    translate([x, y, -epsilon])
        union() {
            cylinder(thickness + epsilon*2, d = fan_diameter, true);
            hole_M3(-mounting_hole_offset, -mounting_hole_offset, thickness, hole_diameter = 3.35);
            
            hole_M3(-mounting_hole_offset, mounting_hole_offset, thickness, hole_diameter = 3.35);
            
            hole_M3(mounting_hole_offset, -mounting_hole_offset, thickness, hole_diameter = 3.35);

            hole_M3(mounting_hole_offset, mounting_hole_offset, thickness, hole_diameter = 3.35);
        }
}

module fan_30mm_labels(x, y, thickness) {
    mounting_hole_offset = 12;
    translate([x, y, -epsilon])
        union() {
            do_text(-mounting_hole_offset-2, -mounting_hole_offset-1, "2", thickness, text_size = 5);
            
            do_text(-mounting_hole_offset-2, mounting_hole_offset-4, "25", thickness, text_size = 5);
            
            do_text(mounting_hole_offset+6, -mounting_hole_offset-1, "3", thickness, text_size = 5);

            do_text(mounting_hole_offset+10, mounting_hole_offset-4, "35", thickness, text_size = 5);        
            }
}
