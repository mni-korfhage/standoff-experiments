module vertical_vent(x, y, width, height, thickness, epsilon = 0.01) {
    triangle_length = width;
    bottom_z = -epsilon;
    top_z = thickness + epsilon;
    vent_points = [
        [width/2, 0, bottom_z], //0
        [width, triangle_length, bottom_z], //1
        [width, height - triangle_length, bottom_z], //2
        [width/2, height, bottom_z], //3
        [0, height-triangle_length, bottom_z], //4
        [0, triangle_length, bottom_z], //5
        [width/2, 0, top_z], //6
        [width, triangle_length, top_z], //7
        [width, height - triangle_length, top_z], //8
        [width/2, height, top_z], //9
        [0, height-triangle_length, top_z], //10
        [0, triangle_length, top_z]]; //11
    vent_faces = [
        [0, 6, 7, 1],
        [1, 7, 8, 2],
        [2, 8, 9, 3],
        [3, 9, 10, 4],
        [4, 10, 11, 5],
        [5, 11, 6, 0],
        [0, 1, 2, 3, 4, 5],
        [11, 10, 9, 8, 7, 6]];
    
    translate([x, y]) 
        polyhedron(vent_points, vent_faces);
}

module vertical_vent_array(width, height, start_x, start_y, end_x, num_vents, thickness, min_space_between_vents = 2.5) {
    space_between_vents = (end_x - start_x - num_vents * width)/(num_vents - 1);
    assert(space_between_vents >= min_space_between_vents, "Not enough space between vents");
    vent_to_vent_offset = width + space_between_vents;
    for (i = [0:num_vents-1]) {
        vertical_vent(start_x + i * vent_to_vent_offset, start_y, width, height, thickness);
    }
}