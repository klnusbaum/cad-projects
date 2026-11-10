// include instead of use, so we get the pitch
include <third-party/gridfinity-extended/modules/gridfinity_constants.scad>
use <third-party/gridfinity-extended/modules/module_gridfinity.scad>

$fa = 1;
$fs = 0.4;

epsilon=0.1;
pad_interface_height=5;
wall_height=30;



module base(pad_length) {
translate([0,0,5])
    cube([pad_length*gf_pitch,gf_pitch,pad_interface_height]);
pad_grid(pad_length,1);
}

module wall(pad_length) {
    translate([0,0,5+pad_interface_height-epsilon]) {
        difference() {
            cube([pad_length*gf_pitch,5,wall_height]);
            translate([10,0,wall_height-5])
               cube([5,5,5]);
            translate([(pad_length*gf_pitch)-15,0,wall_height-5])
               cube([5,5,5]);
        }
    }
}

module side(pad_length) {
    base(pad_length);
    wall(pad_length);
}

side(3);
