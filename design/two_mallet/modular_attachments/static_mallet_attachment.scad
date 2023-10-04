$fa = 1;
$fs = 0.4;

mallet_length = 365; // Hard Mallet
mallet_sphere_radius = 36.75/2;
mallet_sphere_height_h = 32/2;
mallet_handle_radius=9.6/2;

module mallet() {
    cylinder(h=mallet_length+mallet_sphere_height_h, r=mallet_handle_radius);
    translate([0, 0, mallet_length+mallet_sphere_height_h])
        scale([1, 1, mallet_sphere_height_h / mallet_sphere_radius])
        sphere(r=mallet_sphere_radius, center=true);
}

module claw(){
   difference(){
       union(){
          cube([35,5,60]);
            
          translate ([0,5-1,0]) // Bridge Bottom
          cube([35,10+1,5-0.15]);
          translate ([0,11.2,0]) // Claw Bottom
          cube([35,5,10]);
            
          translate ([0,5-1,55+0.15])  // Bridge Top
          cube([35,10+1,5-0.15]);
          translate ([0,11.2,50])// Claw Top
          cube([35,5,10]);
       }
       translate([35/2,8,-0.1])
            cylinder(h=70, r=3/2);
   
    }
}

module mallet_car() {
    difference() {
        union() {
            translate([0, 0, 5])
            cube([25, 25, 80], center=true);
        }
        translate([5, 0, 30])
            rotate([0, 90, 0])
                cylinder(h=19, r=3/2,center = true);
        translate([5, 0, -15])
            rotate([0, 90, 0])
                cylinder(h=19, r=3/2,center = true);
        
        translate([0, 0, -30])
            scale(1.05)
            mallet();
    }
    
}

module attachment() {
    difference() {
        union() {
            cube([35, 6, 50]);
            translate([0, 6, 5+0.15])
                cube([35, 6.01, 40-0.3]);
        }
        union() {
            translate([35/2, 6/2, 3.5-0.001])
                cylinder(h=7, r=3/2, center=true);
            translate([35/2, 6/2, 46.5+0.001])
                cylinder(h=7, r=3/2, center=true);
        }
    }
}

module static_attachment() {
    attachment();
    translate([35/2, 35+12, 50/2])
    rotate([0, 90, 90])
    mallet_car();
}

static_attachment();
//attachment();
//translate([0, -5, -5])
//    claw();