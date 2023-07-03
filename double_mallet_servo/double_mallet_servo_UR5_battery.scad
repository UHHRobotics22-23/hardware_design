$fa = 1;
$fs = 0.4;

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
                cylinder(h=7, r=4);
                
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
            
            translate([-7,0,-6])//Bottomplate
                cube([77,110,6]);
            translate([35,0,-1]) //Frontplate Fix Mallet
                cube([35,6,68.4+1]);
       
            translate([70-6,20,-1]) //Sideplate Fix Mallet
                cube([6,60,68.4+1]);
            translate([70,5,8])
            rotate([0,0,180])
            claw();
            
        }
      
    
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
      screwholes();
        
    }
    
    // 35.5x17.75x108 battery dimensions
    // Battery holder
    translate([30-(18/2), 4, -35.999-6])
    difference() {
        union() {
            translate([-4, -4, -4])
                cube([18+4*2, 24, 36+4]);
            
            translate([-4, -4+45, -4])
                cube([18+4*2, 20, 36+4]);
            
            translate([-4, -4+89, -4]) {
                cube([18+4*2, 14, 36+4]);
                translate([0, -3.99, 36/2-1]) {
                    translate([0, 0, 0])
                        cube([3, 4, 6]);
                    translate([18+5, 0, 0])
                        cube([3, 4, 6]);
                }
            }
        }
        cube([18, 108, 36]);
    };

}
module screwholes(){
     translate([-9,4.3,0]){
            
        translate([6,19,-4]) //Screwhole
                 cylinder(h=30, r=3/2);
        translate([32,19,-4])//Screwhole
                 cylinder(h=30, r=3/2);
        translate([19,32,-4])//Screwhole
                 cylinder(h=30, r=3/2);
        translate([19,6,-4])//Screwhole
                 cylinder(h=30, r=3/2);
         
        translate([40,80,-10])//Screwhole
                 countersunk();
        translate([40,80+22.86,-10])//Screwhole
               
                    countersunk();
                
                 
    }
     translate([-7,0,0-10]){ //Screwholes Sideplate Servo
             translate([3,35,0])
                countersunk();
             translate([3,65,0])
               countersunk();
            translate([3,95,0])
               countersunk();}
            translate([-10,0,68.4-6]){ //Screwholes Frontplate Fix Mallet
             translate([80-10,3,16])
                rotate([0,180,0])
                countersunk();
             translate([80-25,3,16])
               rotate([0,180,0])
                countersunk();
        }
         translate([-10,0,68.4-6]){ //Screwholes Sideplate Fix Mallet
             translate([77,35,16])
                rotate([0,180,])
                countersunk();
             translate([77,65,16])
               rotate([0,180,])
                countersunk();
         }

}
module countersunk(){
    rotate([0,180,]){
    translate([0,0,-6]){
    translate([0,0,+1.67])
        cylinder(20,6/2,6/2);
    cylinder(  1.7,    3/2,    6/2, false);
    translate([0,0,-19]) 
        cylinder(30,3/2,3/2);
    }
    }
    }
module top_plate_housing(){
    difference(){
        union(){
      translate([-7,0,68.4]){//Topplate
                cube([77,125,6]);
          translate([0,0,0])
          cube([40,15,20]);
          translate([0,110,0])
          cube([40,15,20]);
          
          
      }
      translate([-7,30,0]) //Sideplate Servo
        difference() {
            cube([6,80,68.4+1]);
            
            translate([0, 56, 20])
                rotate([0, 90, 0]) {
                    cylinder(h=20, d=3, center=true);
                    translate([-30, 15, 0])
                        cylinder(h=20, d=3, center=true);
                }
        }
                
            
        }
        union(){
            translate([10,10+13.3,68.4+3.49]){ // Bearing hole
                    cylinder(h=7, r=8, center=true);
                     translate([0, 0, -3.5])
                    cylinder(h=2, r=9, center=true);
         }
            
        
          translate([-10,0,68.4-6]){ //Screwholes Frontplate Fix Mallet
             translate([80-10,3,16])
                rotate([0,180,0])
                countersunk();
             translate([80-25,3,16])
               rotate([0,180,0])
                countersunk();
        }
         translate([-10,0,68.4-6]){ //Screwholes Sideplate Fix Mallet
             translate([77,35,16])
                rotate([0,180,])
                countersunk();
             translate([77,65,16])
               rotate([0,180,])
                countersunk();
             
        }
          translate([-7,0,0-6]){ //Screwholes Sideplate Servo
             translate([3,35,0])
                cylinder(h=13, r=3/2);
             translate([3,65,0])
               cylinder(h=13, r=3/2);
             translate([3,95,0])
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
   union(){
   translate([35/2,8,64])
    rotate([0,180,0])
     countersunk();
   translate([35/2,8,-4])
   
     countersunk();
   
   }
}
}
module palm() {
	import("palm_1.stl");
}

//Complete:
//claw();
//mounting_plate();

housing();
difference(){
top_plate_housing();
translate([133,127,217])
rotate([270,0,180])
palm();
}


    
translate([0,13.3,8]){
mounting_plate();
    
    servo();
 translate([10,10,-8])
    drive_shaft_attachment();
}

