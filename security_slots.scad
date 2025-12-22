/* Security slots are 2 rectangles slot_width x slot_height separated by slot_separation
   and whose bottom is offset_from_top mm below the top of the wall.
*/
module security_slots(end_width, end_height, thickness) {
    x_midpoint = end_width/2;
    offset_from_top = 5;
    slot_y = end_height - offset_from_top;
    slot_height = 3;
    slot_width = 5;
    slot_separation = 40;
    union() {
        translate([x_midpoint-slot_separation/2-slot_width, slot_y, -epsilon]) cube([slot_width, slot_height, thickness+2*epsilon]);
        translate([x_midpoint+slot_separation/2, slot_y, -epsilon]) cube([slot_width, slot_height, thickness+2*epsilon]);
    }
}