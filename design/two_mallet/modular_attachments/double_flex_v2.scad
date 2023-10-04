$fa = 1;
$fs = 0.4;
//Maße des Objekts:
//x:45mm y:??mm z:45mm
// Mallet goes 65 mm into Car
side_wall_length = 90;
mallet_length = 375;
mallet_sphere_radius = 39.6/2;
axel_radius = 4;
side_wall_thickness = 5;
mallet_handle_radius=9.6/2;
side_wall_center_distance = mallet_handle_radius*2+1.5+side_wall_thickness/2;

module mallet() {
    cylinder(h=mallet_length, r=mallet_handle_radius);
    translate([0, 0, 365+mallet_sphere_radius])
        sphere(r=mallet_sphere_radius, center=true);
}

module side_wall() {
    difference() {
        cube([side_wall_length, side_wall_length, side_wall_thickness], center=true);
        translate([0, 0, 0])
            cylinder(h=side_wall_thickness+1, r=8, center=true);
             translate([0, 0, side_wall_thickness-1])
            cylinder(h=side_wall_thickness, r=9, center=true);
    }

}

module side_wall_right() {
    difference() {
        side_wall();
        translate([0, 0, -side_wall_thickness-0.1])
            rotate([180, 0, 0])
            screw_holes(side_wall_thickness*2, 3, side_wall_length/2);  // 3mm width holes
    }
}

module side_wall_left() {
    wall_to_wall_distance = side_wall_center_distance*2-side_wall_thickness/2;
    side_wall();
    difference() {//Für die Schrauben
        union() {
            translate([side_wall_length/2-7.5, +40-2.5, wall_to_wall_distance/2])//Struktur Element fo stabilty Y Axes
                cube([15,15,wall_to_wall_distance],center=true);//Stopper
            echo("Die Breite der Wand",wall_to_wall_distance);
            translate([40-2.5, -side_wall_length/2+5+2.5, wall_to_wall_distance/2])
                cube([15,15,wall_to_wall_distance],center=true);//Struktur Element fo stabilty X Axes
            translate([-side_wall_length/2, -side_wall_length/2, 0])//Wall on Y Axes
                union() {
                    cube([side_wall_thickness, side_wall_length, wall_to_wall_distance]);
                    translate([side_wall_thickness+2, 10, wall_to_wall_distance/2+side_wall_thickness/4])
                        rubber_hook();
                 
                };
            translate([-side_wall_length/2, side_wall_length/2, 0])//Wall on X Axes
                union() {
                //rotate([0, 0, -90])
                    //cube([side_wall_thickness, side_wall_length, wall_to_wall_distance]);
                translate([7, -side_wall_thickness-2, wall_to_wall_distance/2+side_wall_thickness/4])
                        rotate([180,0, 0])
                        rubber_hook();
         
                };  
//         translate([-side_wall_length/2+7, (side_wall_length/2)-7, wall_to_wall_distance/2])//Wall on X Axes
//         rubber_attachment();   
     
        }
        translate([0, 0, wall_to_wall_distance])
            screw_holes(6, 3, side_wall_length/2);  // 6mm deep 3mm width holes
    }
}
module rubber_hook(){
    union(){
                        cube([10,5,5],center= true);    
                        translate([4,-2.5,0])
                            cube([5,10,5],center=true);
                        
                        }
    }

module mallet_car() {
    difference() {
        union() {
            cylinder(h=70, r=mallet_handle_radius*2, center=true);
            rotate([90, 0, 0])
                cylinder(h=2*(mallet_handle_radius*2+side_wall_thickness+2), r=axel_radius, center=true);
            rotate([90, 0, 0])
                cylinder(h=2*(mallet_handle_radius*2+1), r=5*2, center=true);
//            translate([0, 0, -37.5])
//                rotate([90, 0, 0])
//                rubber_attachment();
          translate([ -mallet_handle_radius*2,0,-27])
            rotate([90, 0, 0])
                rubber_attachment();
            translate([ mallet_handle_radius*2,0,-27])
            rotate([90, 0, 0])
                rubber_attachment();
        }
        translate([mallet_handle_radius, 0, 30])
            rotate([0, 90, 0])
                cylinder(h=mallet_handle_radius*2, r=3/2,center = true);
        translate([mallet_handle_radius, 0, -15])
            rotate([0, 90, 0])
                cylinder(h=mallet_handle_radius*2, r=3/2,center = true);
        
        translate([0, 0, -30])
            scale(1.07)
            mallet();
    }
    
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

    rotate([0, 90, 0]){
        mallet_car();
        translate([0,0,-30])
        mallet();
    }
    translate([-56.8, +35/2, -25])
        rotate([0, 0, -90])
            attachment();
}

module screw_holes(depth, width, corners) {
    posVal = corners - side_wall_thickness / 2;
    translate([0, 0, -depth+0.001]) {
        translate([-posVal, -posVal, 0])
            cylinder(h=depth, r=width/2);
        translate([-posVal, posVal, 0])
            cylinder(h=depth, r=width/2);
        translate([posVal-5, posVal-5, 0])
            cylinder(h=depth, r=width/2);
        translate([posVal-5, -posVal+5, 0])
            cylinder(h=depth, r=width/2);
        
//        translate([side_wall_length/2-7.5, +40-2.5, wall_to_wall_distance/2])
//            cylinder(h=depth, r=width/2);
        
//        translate([40-2.5, -side_wall_length/2+5+2.5, wall_to_wall_distance/2])
//            cylinder(h=depth, r=width/2);
    }
}

module attachment() {
    difference() {
        union() {
            cube([33.5, 6, 50]);
            translate([6.5, 6, 5+0.15])
                cube([27, 6.01, 40-0.3]);
        }
        union() {
            translate([35/2, 6/2, 3.5-0.001])
                cylinder(h=7, r=3/2, center=true);
            translate([35/2, 6/2, 46.5+0.001])
                cylinder(h=7, r=3/2, center=true);
        }
    }
}

mallet_holder();
// translate([100, 100, 0])
//    side_wall_left();
     
 //    side_wall_right();
//translate([0, 100, 0])
// mallet_car();
 //side_wall_left();
// side_wall_right();
