include <vents.scad>
include <fans.scad>
include <security_slots.scad>
include <holes.scad>
include <standoff.scad>

// Bottom of a module
width = 145;
length = 40;
height = 36;
side_height = 25;

base_thickness = 1;
side_thickness = 1;

epsilon = 0.01;

// Triangle point up, centered at (0,0)
module triangle(x, y, side_length, height, angle = 0, thickness) {
    bottom_z = -epsilon;
    top_z = height + epsilon;
    h = 0.8660254037844386 * side_length / 3;
    triangle_points = [
        [-side_length/2, -h, bottom_z], //0
        [side_length/2, -h, bottom_z], //1
        [0, h*2, bottom_z], //2
        [-side_length/2, -h, top_z], //3
        [side_length/2, -h, top_z], //4
        [0, h*2, top_z], //5
    ];
    triangle_faces = [
        [0, 2, 1],
        [0, 1, 4, 3],
        [1, 2, 5, 4],
        [2, 0, 3, 5],
        [3, 4, 5]
    ];
     translate([x, y, thickness-epsilon]) rotate(angle) 
        polyhedron(triangle_points, triangle_faces);
}



// Triangle point up, "up" edge along y axis
module right_triangle(x, y, x_length, y_length, triangle_thickness, angle = 0) {
    bottom_z = -epsilon;
    top_z = triangle_thickness + epsilon;
    triangle_points = [
        [0, y_length, bottom_z], //0
        [0, 0, bottom_z], //1
        [x_length, 0, bottom_z], //2
        [0, y_length, top_z], //3
        [0, 0, top_z], //4
        [x_length, 0, top_z], //5
    ];
    triangle_faces = [
        [0, 2, 1],
        [0, 1, 4, 3],
        [1, 2, 5, 4],
        [2, 0, 3, 5],
        [3, 4, 5]
    ];
     translate([x, y, 0]) rotate(angle) 
        polyhedron(triangle_points, triangle_faces);
}

module latch(x, y, thickness) {
    union() {
        hole_M3(x, y, thickness+epsilon, hole_diameter = 3.6);
        hole_M3(x-25, y, thickness+epsilon, hole_diameter = 3.6);
    }
}

module quad_lc_coupler(x, y, thickness) {
    coupler_width = 26.25;
    coupler_height = 9.512 + 0.2;
    mounting_hole_offset = 2.225;
    // Adjust for the reality of printing. Make opening slightly larger.
    //x = x - 0.05;
    //coupler_height = coupler_height + 0.05;
    translate([x, y, -epsilon])
        union() {
            cube([coupler_width, coupler_height, thickness + 2 * epsilon]);
            hole_M2(-mounting_hole_offset, coupler_height/2, thickness, hole_diameter=2.5);
            hole_M2(coupler_width + mounting_hole_offset, coupler_height/2, thickness, hole_diameter=2.5);
        };
}

module cover_mount_outer(x, y, on_left, thickness) {
    mount_height = 6;
    mount_diameter = 9;
    if (on_left) {
        translate([0, x, y])
        rotate([90, 0, 90]) { 
            cylinder(mount_height, d=mount_diameter);
        }
    } else {
        translate([-mount_height+thickness, x, y])
        rotate([90, 0, 90]) { 
            cylinder(mount_height, d=mount_diameter);
        }
    };
}

module cover_mount_inner(x, y, on_left, thickness) {
    mount_height = 6;
    hole_diameter = 3.9+0.2;
        if (on_left) {
            translate([0, x, y])
            rotate([90, 0, 90]) { 
                translate([0, 0, -epsilon]) cylinder(mount_height+2*epsilon, d=hole_diameter, $fa=1, $fs=0.5);
            }
        } else {
            translate([-6+thickness, x, y])
            rotate([90, 0, 90]) { 
                translate([0, 0, -epsilon]) cylinder(mount_height+2*epsilon, d=hole_diameter, $fa=1, $fs=0.5);
            }
        };
}

// location is the coordinate of the center line of the brace and can be an array.
module side_brace(location, brace_bottom_length = 10, brace_height, brace_thickness = 5, on_left, side_thickness, base_thickness) {
    if (on_left) {
        support_angle = [90, 0, 0];
    } else {
        support_angle = [90, 0, 180];
    };
    for (loc = location) {
    translate([side_thickness, on_left? brace_thickness/2: -brace_thickness/2, base_thickness]) right_triangle(0, loc, brace_bottom_length, brace_height-base_thickness, brace_thickness, [90, 0, on_left? 0 : 180]);
    }
}

/////// SIDE ////////
// Brace locations is an array of locations for the centerlines of the braces
module side(length, height, side_thickness, x = 0, y = 0, on_left = true, base_thickness, brace_locations = [25]) {

    translate([x, y, 0]) 

        difference() {
            union() {
                cube([side_thickness, length, height]);
                cover_mount_outer(15, 10, on_left, side_thickness);
                //cover_mount_outer(35, 10, on_left, thickness);
                side_brace(location = brace_locations, brace_height = height, on_left = on_left, side_thickness = side_thickness, base_thickness = base_thickness);

            };
            cover_mount_inner(15, 10, on_left, side_thickness);
            //cover_mount_inner(35, 10, on_left, thickness);
        }
}

module do_text(x, y, the_text, thickness, text_size = 4.5, font = "Arial:style=Bold") {
    text_height = 0.8;
    text_base = thickness - 0.1;
    translate([x, y, -text_height+epsilon]) linear_extrude(text_height) rotate([0, 180, 0]) text(the_text, text_size, font=font);
}

module front_panel(x, y, thickness) {
    protocase_x_origin = 12;
    protocase_y_origin = 22;
    translate([x, y, -epsilon])
        union() {
            hole_M2(15.3-protocase_x_origin, 31.8-protocase_y_origin, thickness, 3.0); // mounting hole
            hole_M2(15.3-protocase_x_origin, 23.3-protocase_y_origin, thickness, 3.0); // mounting hole
            hole(23.25-protocase_x_origin, 23.775-protocase_y_origin, thickness, 4.2); // down tact switch
            hole(23.25-protocase_x_origin, 31.325-protocase_y_origin, thickness, 4.2); // up tact switch
            translate ([34.2-protocase_x_origin, 1.6-2, 0]) cube([22.74, 11.86, thickness + 2 * epsilon]); // display
            hole(72.8-protocase_x_origin, 23.775-protocase_y_origin, thickness, 4.4); // illuminated tact switch
            hole(72.8-protocase_x_origin, 31.325-protocase_y_origin, thickness, 5.7); // 5mm LED
            hole_M2(80.2-protocase_x_origin, 31.8-protocase_y_origin, thickness, 3.0); // mounting hole
            hole_M2(80.2-protocase_x_origin, 23.3-protocase_y_origin, thickness, 3.0); // mounting hole
            
        };
}

module front_panel_labels(x, y, thickness) {
    mounting_hole_offset = 12;
    translate([x, y, -epsilon])
        union() {
            do_text(-mounting_hole_offset-2, -mounting_hole_offset-1, "2", thickness, text_size = 5);
            
            do_text(-mounting_hole_offset-2, mounting_hole_offset-4, "25", thickness, text_size = 5);
            
            do_text(mounting_hole_offset+6, -mounting_hole_offset-1, "3", thickness, text_size = 5);

            do_text(mounting_hole_offset+10, mounting_hole_offset-4, "35", thickness, text_size = 5);        
            }
}

module front(width, height, thickness) {
    rotate([90, 0, 0])
        union() {
            difference() {
                cube([width, height, thickness]);
                vertical_vent_array(width = 3, height = 10, start_x = 5, start_y = 4, end_x = width - 5, num_vents = 21, thickness = thickness);
                vertical_vent_array(width = 3, height = 10, start_x = 3, start_y = 21.5, end_x = 11.5, num_vents = 2, thickness = thickness);   
                front_panel(12, 20, thickness);
                vertical_vent_array(width = 3, height = 10, start_x = 84.5, start_y = 21.5, end_x = 93.5, num_vents = 2, thickness = thickness);   
                quad_lc_coupler(99.375, 22, thickness);
                vertical_vent_array(width = 3, height = 10, start_x = 132, start_y = 21.5, end_x = 141, num_vents = 2, thickness = thickness);        
            };
            triangle(30, 29, 4, 1, [0, 0, 0], thickness);
            triangle(30, 22, 4, 1, [0, 0, 180], thickness);
            triangle(66, 22, 4, 1, [0, 0, 90], thickness);
        }
}




module backplane_connector_opening(x, y, thickness) {
    width = 35;
    height = 10.35;
    translate([x, y, -epsilon])
        union() {
            cube([width, height, thickness + 2 * epsilon]);
        };
}



module end(width, height, thickness, x = 0, y = 0) {
    translate([x, y, 0]) 
        rotate([90, 0, 0])
            union() {
                difference() {
                    cube([width, height, thickness]);
                    fan_30mm(22.35, 20, thickness);
                    backplane_connector_opening(64.97, 5, thickness);
                    latch(94.97, 25, thickness);
                    fan_30mm(124, 20, thickness);
                    security_slots(width, height, thickness);
                };
                //fan_30mm_labels(22.35, 20, thickness);
            }
}

module bottom(width, height, thickness) {
    cube([width, height, thickness]);
}

union() {
    text_height = 1.25;
    text_base = base_thickness-epsilon;
    bottom(width, length, base_thickness);
    side(length, side_height, side_thickness, on_left = true, base_thickness = base_thickness);
    side(length, side_height, side_thickness, x=width-side_thickness, on_left = false, base_thickness = base_thickness);
    front(width, height, side_thickness);
    end(width, height, side_thickness, 0, length);
    translate([width * .75, length/2, text_base]) linear_extrude(text_height) text("#4", 4.5, font="Arial:style=Bold");
}