// Tapered cabinet support with open screw-access corners
// OpenSCAD units are millimeters.
//
// Geometry:
// - Face A (bottom): 2.25" x 2.25"
// - Opposite face (top): 1.00" x 1.00"
// - Total height: 1.50"
// - Four mounting holes: 1.25" center-to-center
// - 3/16" diameter holes through the first 0.25" from Face A
// - Above the flange, each corner is opened for screw-head/driver access

inch = 25.4;

base_size       = 2.25 * inch;
top_size        = 1.75 * inch;
total_height    = 2.0 * inch;

flange_height   = 0.25 * inch;

hole_spacing    = 1.25 * inch;
mount_hole_dia  = 3/16 * inch;

// Corner opening sized for approximately 1/2" screw-head clearance.
// Increase this if your actual screw heads or driver need more room.
head_clearance_dia = 0.60 * inch;
head_clearance_rad = head_clearance_dia / 2;

epsilon = 0.20;
$fn = 96;

// Centered square frustum.
module tapered_square_frustum() {
    hull() {
        translate([0, 0, 0])
            linear_extrude(height = epsilon)
                square([base_size, base_size], center = true);

        translate([0, 0, total_height - epsilon])
            linear_extrude(height = epsilon)
                square([top_size, top_size], center = true);
    }
}

// Removes the upper portion of one corner to expose the screw head.
// sx and sy are each -1 or +1.
module corner_relief(sx, sy) {
    hole_x = sx * hole_spacing / 2;
    hole_y = sy * hole_spacing / 2;

    x_start = sx > 0 ? hole_x - head_clearance_rad : -base_size;
    x_end   = sx > 0 ? base_size : hole_x + head_clearance_rad;

    y_start = sy > 0 ? hole_y - head_clearance_rad : -base_size;
    y_end   = sy > 0 ? base_size : hole_y + head_clearance_rad;

    translate([x_start, y_start, flange_height])
        cube([
            x_end - x_start,
            y_end - y_start,
            total_height - flange_height + epsilon
        ]);
}

difference() {
    tapered_square_frustum();

    for (sx = [-1, 1])
        for (sy = [-1, 1]) {
            hole_x = sx * hole_spacing / 2;
            hole_y = sy * hole_spacing / 2;

            // 3/16" mounting hole through only the 0.25" flange.
            translate([hole_x, hole_y, -epsilon])
                cylinder(
                    h = flange_height + 2 * epsilon,
                    d = mount_hole_dia
                );

            // Open the upper corner for screw-head and driver access.
            corner_relief(sx, sy);
        }
}
