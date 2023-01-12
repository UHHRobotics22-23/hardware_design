$fa = 1;
$fs = 0.4;

mallet_length = 393;
mallet_sphere_radius = 39.6/2;
axel_radius = 5;
side_wall_thickness = 5;
mallet_handle_radius=9.6/2;
side_wall_center_distance = mallet_handle_radius*2+1.5+side_wall_thickness/2;

module mallet() {
    cylinder(h=mallet_length+mallet_sphere_radius, r=mallet_handle_radius);
    translate([0, 0, mallet_length+mallet_sphere_radius])
        sphere(r=mallet_sphere_radius, center=true);
}

module side_wall() {
    difference() {
        cube([100, 100, side_wall_thickness], center=true);
        translate([0, 0, 0])
            cylinder(h=side_wall_thickness+1, r=axel_radius*1.1, center=true);
    }
}

module side_wall_right() {
    difference() {
        side_wall();
        translate([0, 0, -side_wall_thickness-0.1])
            rotate([180, 0, 0])
            screw_holes(side_wall_thickness*2, 3, 50);  // 3mm width holes
    }
}

module side_wall_left() {
    wall_to_wall_distance = side_wall_center_distance*2-side_wall_thickness/2;
    side_wall();
    difference() {
        union() {
            translate([-20, -(mallet_handle_radius*2+5), 0])
                cylinder(h=wall_to_wall_distance, r=5);
            translate([-50, -50, 0])
                union() {
                    cube([side_wall_thickness, 100, wall_to_wall_distance]);
                    translate([side_wall_thickness, 5, wall_to_wall_distance/2+side_wall_thickness/2])
                        rotate([90, 0, 0])
                        rubber_attachment();
                };
            translate([-50, 50, 0])
                rotate([0, 0, -90])
                cube([side_wall_thickness, 100, wall_to_wall_distance]);
        }
        translate([0, 0, wall_to_wall_distance])
            screw_holes(6, 3, 50);  // 6mm deep 3mm width holes
    }
}

module mallet_car() {
    difference() {
        union() {
            cylinder(h=70, r=mallet_handle_radius*2, center=true);
            rotate([90, 0, 0])
                cylinder(h=2*(mallet_handle_radius*2+side_wall_thickness+2), r=axel_radius, center=true);
            rotate([90, 0, 0])
                cylinder(h=2*(mallet_handle_radius*2+1), r=axel_radius*2, center=true);
            translate([-mallet_handle_radius*2, 0, -30])
                rotate([90, 0, 0])
                rubber_attachment();
        }
        
        translate([0, 0, -30])
            scale(1.1)
            mallet();
    }
    
}

module rubber_attachment() {
    rotate_extrude(angle=360) {
        translate([3, 0, 0])
            circle(r=1);
    }
}

module mallet_holder() {
    translate([0, side_wall_center_distance, 0])
        rotate([90, 0, 0])
        side_wall_right();

    translate([0, -side_wall_center_distance, 0])
        rotate([-90, 0, 0])
        side_wall_left();

    rotate([0, 90, 0])
        mallet_car();
}

module screw_holes(depth, width, corners) {
    posVal = corners - side_wall_thickness / 2;
    translate([0, 0, -depth+0.001]) {
        translate([-posVal, -posVal, 0])
            cylinder(h=depth, r=width/2);
        translate([-posVal, posVal, 0])
            cylinder(h=depth, r=width/2);
        translate([posVal, posVal, 0])
            cylinder(h=depth, r=width/2);
    }
}

mallet_holder();

// translate([100, 100, 0])
    // side_wall_left();
    // side_wall_right();

// mallet_car();
// side_wall_left();
// side_wall();
