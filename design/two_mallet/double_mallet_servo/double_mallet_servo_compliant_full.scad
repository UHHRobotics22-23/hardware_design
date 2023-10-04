/*
 * Modified version of the double_mallet_servo with the flexible attachment included. For more documentation see the base files.
 */

$fa = 1;
$fs = 0.4;

side_wall_length = 90;
mallet_length = 365; // Hard Mallet
mallet_sphere_radius = 36.75/2;
mallet_sphere_height_h = 32/2;
axel_radius = 4;
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
        translate([0, 0, -30])
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


/////////////////////////SERVO MODEL////////////////////////////
module servo(){
    color([0,0,1])
    difference (){
    union(){    
    rotate([90,0,90])//Servo Corpus
        cube([40, 39.5, 20]); 
    
    translate([0,40,8])//Screwholders
        cube([20,7.25,2.6]); 
    translate([0,-7.25,8])
        cube([20,7.25,2.6]);
    
    translate([10,10,-2]) //Drive shaft
        cylinder(h=3, r=6.5);
    translate([10,10,-5.5])
        cylinder(h=4, r=5.8/2);
        
    translate([10-3.5,-4.7,33])
        cube([7,8,5]);
        
    }
    ///////////Cutting///////////
    
    union(){ //Cut out Screwholes
    screwholes_servo();
    translate([20,40,0])
    rotate([0,0,180])
    screwholes_servo();
    }
}
  
}

module screwholes_servo(){
     translate([0, 0, 7.9]) {
        translate([5, -7.25/2, 0]){
            cylinder(h=3, r=4.4/2);
            translate([-1.8,-4.8,0])
            cube([3.6, 4, 3]); 
        }
           translate([15, -7.25/2, 0]){
            cylinder(h=3, r=4.4/2);
            translate([-1.8,-4.8,0])
            cube([3.6, 4, 3]); 
        }
      
    }
}

module drive_shaft_attachment(){
    translate([-19,-19,0]){
        difference(){
            union(){
            
             translate([0,14.5,0])
                cube([38, 9, 2.77]); 
             translate([14.5,0,0])
                cube([9, 38, 2.77]); 
            translate([19,19,0])
                cylinder(h=5.4, r=4.4);   
                }
             union(){   
             translate([19,19,-00.1])//Driftshaft Clutch
                cylinder(h=6, r=5.8/2);
             translate([6,19,-00.1]) //Screwhole
                 cylinder(h=30, r=3/2);
              translate([32,19,-00.1])//Screwhole
                 cylinder(h=30, r=3/2);
              translate([19,32,-00.1])//Screwhole
                 cylinder(h=30, r=3/2);
              translate([19,6,-00.1])//Screwhole
                 cylinder(h=30, r=3/2);
             }
        }
    }
    
}

////////////////////////////////Servo Moveable Mallet//////////////////////////////
module mounting_plate(){
     color([0,1,0])
    difference(){
        union(){
                
          
               
            translate([0,-13.3,0]) //Sidewalls
                cube([35,6,60]);
             translate([0,40+7.5,0])
                cube([35,5,60]);
            
             translate([0,-10,54])//Topplate
                cube([35,60,6]);
            
            translate([20,-10,0])//inner structure
                cube([5,60,60]);
            
            translate([0,40,10.65])//counterpart screws
                cube([23,12,20]);
            translate([0,-12,10.65])
                cube([23,12,20]);
            
            translate([10,10,59]) //Axle Top
                cylinder(h=8, r=4);
                
            translate([35,-8.3,0]) // Claw for Mounting Plate
            rotate([0,0,180])
            claw();
        }
       union(){ ///////////Cutting///////////
          translate([15, -7.25/2, 9.9]) // Screwholes Mouting Plate
                cylinder(h=6, r=3/2);
          translate([5, -7.25/2, 9.9])
                cylinder(h=6, r=3/2);
           translate([20,40,0]){
               rotate([0,0,180]){
                    translate([15, -7.25/2, 9.9])
                        cylinder(h=6, r=3/2);
                    translate([5, -7.25/2, 9.9])
                        cylinder(h=6, r=3/2);
               }
           }
        translate([19,-5,40])//Cable channel
                cube([7,9,6]);
           
//        translate([0, -9.3, 0]){ // Screwholes for Mounting Plate
//            rotate([90,0,0]){
//                translate([30,5,0])
//                cylinder(h=5, r=3/2);
//                translate([5,5, 0])
//                cylinder(h=5, r=3/2);
//                translate([30,55, 0])
//                cylinder(h=5, r=3/2);
//                translate([5,55, 0])
//                cylinder(h=5, r=3/2);
//                translate([30,30, 0])
//                cylinder(h=5, r=3/2);
//                translate([5,30, 0])
//                cylinder(h=5, r=3/2);
//              
//            }
//        }
        
    
           
       }
    }
}


////////////////////////////////Housing # Main Structure//////////////////////////////
module housing(){
    difference(){
        union(){
            
            
            translate([-10,0,-6])//Bottomplate
                cube([80,60,6]);
            translate([35,0,-1]) //Frontplate Fix Mallet
                cube([35,6,68.4+1]);
       
            translate([70-6,20,-1]) //Sideplate Fix Mallet
                cube([6,30,68.4+1]);
            translate([70,5,8])
            rotate([0,0,180])
            claw();
        }
        union(){
    
//         translate([35, +4, 8]){ // Screwholes for Mounting Plate
//            rotate([90,0,0]){
//                translate([30,5,0])
//                cylinder(h=6, r=3/2);
//                translate([5,5, 0])
//                cylinder(h=6, r=3/2);
//                translate([30,55, 0])
//                cylinder(h=6, r=3/2);
//                translate([5,55, 0])
//                cylinder(h=6, r=3/2);
//                translate([30,30, 0])
//                cylinder(h=6, r=3/2);
//                translate([5,30, 0])
//                cylinder(h=6, r=3/2);
//              
//            }
//        }
      
         translate([-9,4.3,0]){
            
        translate([6,19,-4]) //Screwhole
                 cylinder(h=30, r=3/2);
        translate([32,19,-4])//Screwhole
                 cylinder(h=30, r=3/2);
        translate([19,32,-4])//Screwhole
                 cylinder(h=30, r=3/2);
        translate([19,6,-4])//Screwhole
                 cylinder(h=30, r=3/2);
    }
     translate([-10,0,0-6.1]){ //Screwholes Sideplate Servo
             translate([3,35,0])
                cylinder(h=13, r=3/2);
             translate([3,55,0])
               cylinder(h=13, r=3/2);}

}
         
    
}
     
 

}
module top_plate_housing(){
    difference(){
        union(){
      translate([-10,0,68.4])//Topplate
                cube([80,60,6]);
      translate([-10,30,0]) //Sideplate Servo
                cube([6,30,68.4+1]);
            
        }
        union(){
            translate([10,10+13.3,68.4+3.49]){ // Bearing hole
                    cylinder(h=7, r=8, center=true);
                     translate([0, 0, -3.5])
                    cylinder(h=2, r=9, center=true);
         }
            
        
          translate([-10,0,68.4-6]){ //Screwholes Frontplate Fix Mallet
             translate([80-10,3,0])
                cylinder(h=13, r=3/2);
             translate([80-25,3,0])
               cylinder(h=13, r=3/2);
        }
         translate([-10,0,68.4-6]){ //Screwholes Sideplate Fix Mallet
             translate([77,25,0])
                cylinder(h=13, r=3/2);
             translate([77,45,0])
               cylinder(h=13, r=3/2);
             
        }
          translate([-10,0,0-6]){ //Screwholes Sideplate Servo
             translate([3,35,0])
                cylinder(h=13, r=3/2);
             translate([3,55,0])
               cylinder(h=13, r=3/2);
             
        }
    }
    
    
}
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

//Complete:
// claw();
// mounting_plate();


translate([-30, -60, -35]) {
    //translate([0, -5.8+30, 0]) {
    //translate([20, 36.8, 0]) {
    housing();
    top_plate_housing();
        
    //translate([0,13.3,8]){
    //mounting_plate();

    //servo();
    //translate([10,10,-8])
    //    drive_shaft_attachment();
    //}

    // attachment 1 (fixed)
    translate([70-35/2,-side_wall_length/2-12,8+60/2])
    rotate([0, 0, -90])
    mallet_holder();

    // attachment 2 (dynamic)
    //translate([70-35/2-60/2-5,-side_wall_length/2-12,8+60/2])
    //rotate([180, 0, -90])
    //mallet_holder();
//}
}