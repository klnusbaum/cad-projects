// include instead of use, so we get the pitch
include <third-party/gridfinity-extended/modules/gridfinity_constants.scad>
use <third-party/gridfinity-extended/modules/module_gridfinity.scad>
use <third-party/gridfinity-extended/modules/module_gridfinity_baseplate.scad>

$fa = 1;
$fs = 0.4;

epsilon=0.01;
pad_interface_height=5;
wall_height=30;
wall_width=5;
wall_support_dim=9;
peg_height=5;
peg_radius=3;
peg_tolerance=0.2;
pad_width=6;
lid_height=5;

part="assembled";

module peg_hole() {
    cylinder(r=peg_radius, h=peg_height);
}

module peg() {
    cylinder(h=peg_height, r=peg_radius-peg_tolerance);
}

module lid(pad_length) {
    translate([0,0,wall_height+pad_interface_height+peg_height]) {
        difference(){
            cube([pad_length*gf_pitch, pad_width * gf_pitch, lid_height]);
            translate([gf_pitch/2,wall_width+wall_support_dim/2,0]){
                peg_hole();
            }
            translate([gf_pitch/2, pad_width*gf_pitch - (wall_width+wall_support_dim/2),0]){
                peg_hole();
            }
            translate([pad_length*gf_pitch-(gf_pitch/2),wall_width+wall_support_dim/2,0]){
                peg_hole();
            }
            translate([pad_length*gf_pitch-(gf_pitch/2),pad_width*gf_pitch - (wall_width+wall_support_dim/2),0]){
                peg_hole();
            }
        }
        translate([0,0,lid_height-epsilon]) {
            gridfinity_baseplate(num_x=pad_length, num_y=pad_width);
        }
    }
}

module base(pad_length) {
translate([0,0,5])
    cube([pad_length*gf_pitch,gf_pitch,pad_interface_height]);
    pad_grid(pad_length,1);
}

module wall_support() {
    cube([wall_support_dim,wall_support_dim,wall_height]);
    translate([wall_support_dim/2,wall_support_dim/2,wall_height]) {
        peg();
    }
}

module wall(pad_length) {
    translate([0,0,5+pad_interface_height-epsilon]) {
        cube([pad_length*gf_pitch,wall_width,wall_height]);
        translate([(gf_pitch-wall_support_dim)/2,wall_width,0]){
            wall_support();
        }
        translate([pad_length*gf_pitch-(gf_pitch+wall_support_dim)/2,wall_width,0]){
            wall_support();
        }
    }
}
module side(pad_length) {
    base(pad_length);
    wall(pad_length);
}
module front_left_side() {
    side(3);
}
module front_right_side() {
    translate([3*gf_pitch,6*gf_pitch,0])
    rotate([0,0,180])
    side(3);
}
module back_left_side() {
    translate([-(4*gf_pitch), 0,0])
    side(4);
}
module back_right_side() {
    translate([0, 6*gf_pitch,0])
    rotate([0,0,180])
    side(4);
}

module front_lid() {
    lid(3);
}

module back_lid() {
    translate([-4*gf_pitch, 0,0])
    lid(4);
}


module assembled() {
    front_left_side();
    front_right_side();
    back_left_side();
    back_right_side();
    front_lid();
    back_lid();
}

if (part == "front_left_side") {
    front_left_side();
} else if (part == "front_right_side") {
    front_right_side();
} else if (part == "back_left_side") {
    back_left_side();
} else if (part == "back_right_side") {
    back_right_side();
} else if (part == "front_lid") {
    front_lid();
} else if (part == "back_lid") {
    back_lid();
} else {
    assembled();
}
