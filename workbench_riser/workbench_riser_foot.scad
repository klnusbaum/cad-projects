inch = 25.4;

// Overall pad
pad_x = 2.50 * inch;
pad_y = 2.50 * inch;

// You want 1/2" of material beneath the leg
under_leg_height = 0.50 * inch;

// Recess depth
recess_depth = 0.25   * inch;

// Total height
pad_height = under_leg_height + recess_depth;

// Actual workbench foot size
leg_x = 2.00 * inch;
leg_y = 2.00 * inch;

// Clearance on each side
clearance = 0.02 * inch;

// Rounded outside corners
corner_radius = 0.15 * inch;

$fn = 64;

module rounded_box(size=[10,10,10], r=2) {
    linear_extrude(height=size[2])
        offset(r=r)
            offset(delta=-r)
                square([size[0], size[1]], center=true);
}

difference() {

    rounded_box(
        [pad_x, pad_y, pad_height],
        corner_radius
    );

    // Recess from the top
    translate([
        0,
        0,
        pad_height - recess_depth/2
    ])
        cube([
            leg_x + 2*clearance,
            leg_y + 2*clearance,
            recess_depth + 0.2
        ], center=true);
}