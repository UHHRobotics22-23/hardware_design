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
    union(){ //Cut out Screwholes
    screwholes();
    translate([20,40,0])
    rotate([0,0,180])
    screwholes();
    }
}
  
}

module screwholes(){
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
             }
        }
    }
    
}

////////////////////////////////Mounting Plate//////////////////////////////
module mounting_plate(){
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
            translate([10,10,59])
                cylinder(h=11, r=5);
        }
       union(){
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
        }
    }
}
mounting_plate();
//servo();
//drive_shaft_attachment();

//Complete:
servo();
 translate([10,10,-8])
    drive_shaft_attachment();


