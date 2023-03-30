$fa = 1;
$fs = 0.4;

mallet_length = 365; // Hard Mallet
mallet_sphere_radius = 36.75/2;
mallet_sphere_height_h = 32/2;
axel_radius = 5;
side_wall_thickness = 5;
mallet_handle_radius=9.6/2;
side_wall_center_distance = mallet_handle_radius*2+1.5+side_wall_thickness/2;

module mallet() {
    cylinder(h=mallet_length+mallet_sphere_height_h, r=mallet_handle_radius);
    translate([0, 0, mallet_length+mallet_sphere_height_h])
        scale([1, 1, mallet_sphere_height_h / mallet_sphere_radius])
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
            translate([-20, -(mallet_handle_radius*2+5)-1, wall_to_wall_distance/2])//The -1 give some space for the felt stopper
                cube([10,10,wall_to_wall_distance],center=true);
            translate([-50, -50, 0])
                union() {
                    cube([side_wall_thickness, 100, wall_to_wall_distance]);
                    translate([side_wall_thickness+2, 10, wall_to_wall_distance/2+side_wall_thickness/4])
                        union(){
                        cube([10,5,5],center= true);    
                        translate([4,-2.5,0])
                            cube([5,10,5],center=true);
                        }
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
            translate([0, 0, 5])
            cube([mallet_handle_radius*5, mallet_handle_radius*5, 80], center=true);
        }
        translate([mallet_handle_radius, 0, 30])
            rotate([0, 90, 0])
                cylinder(h=mallet_handle_radius*4, r=3/2,center = true);
        translate([mallet_handle_radius, 0, -15])
            rotate([0, 90, 0])
                cylinder(h=mallet_handle_radius*4, r=3/2,center = true);
        
        translate([0, 0, -30])
            scale(1.05)
            mallet();
    }
    
}

module mallet_car_mod() {
    mallet_car();
    translate([0, 0, -mallet_handle_radius*2-70/2+0.001])
        cube([70, mallet_handle_radius*4, mallet_handle_radius*4], center=true);
    side_slope(mallet_handle_radius*4+10, mallet_handle_radius*4*1.6);
    rotate([0, 0, 180])
        side_slope(mallet_handle_radius*4+10, mallet_handle_radius*4*1.6);
}

module rubber_attachment() {
    rotate_extrude(angle=360) {
        translate([4, 0, 0])
            circle(r=1.5);
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

module side_slope(slope_height, slope_width) {
    // I don't understand the 0.4, but it seems necessary
    translate([0, mallet_handle_radius*2+slope_width/2-0.001, -slope_height/2-70/2+mallet_handle_radius*2+0.4])
    difference() {
        cube([mallet_handle_radius*5, slope_width, slope_height], center=true);
        translate([-100, -slope_width/2, slope_height/2])
            rotate([-40, 0, 0])
            cube([200, 200, 200]);
    }
}

//mallet_holder();

// translate([100, 100, 0])
    // side_wall_left();
    // side_wall_right();
//side_slope(mallet_handle_radius*4+10, mallet_handle_radius*4*1.6);
translate([0, 0, 40+mallet_handle_radius*3]) {
    mallet_car_mod();
    translate([0, 0, -30])
        mallet();
}
 //side_wall_left();
 //side_wall_right();
