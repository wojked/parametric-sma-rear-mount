/* [MOUNT] */
WIDTH = 25.0;
MOUNT_DIAMETER = 5.5;  //4.95
MOUNT_THICKNESS = 2.5;
MOUNT_HEIGHT= 7.00;     // 6.75

/* [BRIDGE] */
BRIDGE_WIDTH = WIDTH - 10;   //8 is not catching up to much
MIN_BRIDGE_WIDTH = WIDTH - 13;
BRIDGE_HEIGHT = 10;     // MOUNT_HEIGHT -->14
BRIDGE_ANGLE = 55;      // [0:5:60]
BRIDGE_X_OFFSET = 18;    // [0:1:20]
BRIDGE_Z_OFFSET = 3.5;    // [0:1:15] -->2.5
BRIDGE_THICKNESS = 1.5;

/* [VERTICAL_BRIDGE] */
VERTICAL_BRIDGE_WIDTH = WIDTH - 6;  //-6
VERTICAL_BRIDGE_THICKNESS = 1;
VERTICAL_BRIDGE_OFFSET = -VERTICAL_BRIDGE_THICKNESS/2;

/* [SMA] */
SMA_HOLE_OFFSET = -0.5; //1, -3.2
SMA_HOLE_DIAMETER = 6.5;
SMA_OUTLINER_DIAMETER = 0;
SMA_CUTOUT_WIDTH = WIDTH - 4*MOUNT_THICKNESS - 4.2; //-3.8
SMA_CUTOUT_HEIGHT = 8; //12

/* [SHELF] */
WITH_SHELF = true;    //[true, false]
VTX_WIDTH = 17.5;
SHELF_WIDTH = VTX_WIDTH + 4.5 ; 
SHELF_LENGTH = 18;
SHELF_Y_OFFSET = 8;    //10
SHELF_THICKNESS = 1.2;
ADDITIONAL_CUTOUT_ANGLE = BRIDGE_ANGLE - 35;
ADDITIONAL_CUTOUT_Z_OFFSET = 1;

/* [ARROWS] */
WITH_ARROWS = true;     //[true, false]
ARROWS_SPACER = 6.5;
ARROWS_THICKNESS = 0.5;
ARROWS_ARM_WIDTH = 1.5;
ARROWS_ARM_LENGTH = 7.5;

/* [META] */
ZIPTIE_WIDTH = 3.5;
ZIPTIE_THICKNESS = 1.6; //0.7

TEST_WIDTH = false;     // [false, true]
HULL_TYPE = 2;          // [0,1,2]
CORNERS_DIAMETER = 4;
BOUNDED = true;         // [true, false]
FN = 64;                // [0:32:256]  

/* [HIDDEN] */
$fn = FN;
DEBUG = false;

rotate([180,0,0])
sma_holder();

module sma_holder(){
    difference(){
        if(TEST_WIDTH){
            union(){
                side_mounts(2);       
                vertical_bridge(2);                     
            }
        }
        else{
            if(HULL_TYPE==0){
                union(){
                    if(WITH_SHELF){
                        translate([0,0,MOUNT_HEIGHT])                        
                        shelf(SHELF_THICKNESS);
                    }                    
                    side_mounts(MOUNT_HEIGHT);
                    translate([0, VERTICAL_BRIDGE_OFFSET, 0])     
                    vertical_bridge(MOUNT_HEIGHT);                
                    bridge_with_mount();   
                }            
            }
            if(HULL_TYPE==1){            
                hull(){
                    if(WITH_SHELF){
                        translate([0,0,MOUNT_HEIGHT])                        
                        shelf(SHELF_THICKNESS);
                    }                     
                    side_mounts(MOUNT_HEIGHT);
                    translate([0, VERTICAL_BRIDGE_OFFSET, 0])     
                    vertical_bridge(MOUNT_HEIGHT);
                    bridge_with_mount();            
                }
            }
            if(HULL_TYPE==2){
                union(){
                    if(WITH_SHELF){
                        translate([0,0,MOUNT_HEIGHT])
                        shelf(SHELF_THICKNESS);
                    }                    
                    side_mounts(MOUNT_HEIGHT);
                    hull(){
                        translate([0, VERTICAL_BRIDGE_OFFSET, 0])                        
                        vertical_bridge(MOUNT_HEIGHT);                
                        bridge_with_mount();                            
                    }
                }            
            }
        }      

        // Poles
        side_poles();
        
        
        // Holder cutouts
        translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
        rotate([BRIDGE_ANGLE,0,0])       
        union(){
            translate([0,SMA_HOLE_OFFSET,0])
            sma_hole();
            
            translate([0,SMA_HOLE_OFFSET,0])
            sma_outliner();                 
            
            translate([0,SMA_HOLE_OFFSET,0])
            sma_plate();        
        }
        
        //Additional cutout
        if(WITH_SHELF){
            union(){
                width = BRIDGE_WIDTH - 2;
                cutout_thickness = 5;
                translate([0,2,MOUNT_HEIGHT-cutout_thickness/2+ADDITIONAL_CUTOUT_Z_OFFSET])
                rotate([ADDITIONAL_CUTOUT_ANGLE,0,0])
                cube([width, 30 , cutout_thickness],true);            
            }
        }
        
        if(BOUNDED){
            // LOWER bound
            translate([0,0,-WIDTH/2])
            cube([WIDTH*2, WIDTH*2, WIDTH], true);
            
            // UPPER bound    
            translate([0,0,MOUNT_HEIGHT+WIDTH/2])
            cube([WIDTH*2, WIDTH*2, WIDTH], true);   
        }        
        
    }
    
    if(DEBUG){
        translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
        rotate([BRIDGE_ANGLE,0,0])       
        union(){
            translate([0,SMA_HOLE_OFFSET,0])
            sma_hole();
            
            translate([0,SMA_HOLE_OFFSET,0])
            sma_outliner();                 
            
            translate([0,SMA_HOLE_OFFSET,0])            
            sma_plate();        
        }                
    }
    
    if(WITH_ARROWS){
        rotate([180,0,0])
        translate([0,-2,0])
        union(){
            translate([0,-2,0])
            arrows(ARROWS_THICKNESS);
            translate([0,-ARROWS_SPACER,0])
            arrows(ARROWS_THICKNESS);    
        }
    }
    
}

module side_mounts(height){
    x_offset = WIDTH/2;
    
    translate([-x_offset,0,0])    
    mount(height);

    translate([x_offset,0,0])
    mount(height);    
}

module mount(height){
    outside_diameter = MOUNT_DIAMETER + MOUNT_THICKNESS;    
    
    translate([0,0, height/2])
    cylinder(height, outside_diameter/2, outside_diameter/2, true);
}

module side_poles(){
    x_offset = WIDTH/2;
    
    translate([-x_offset,0,0])    
    pole();

    translate([x_offset,0,0])
    pole();       
}

module pole(){
    outside_diameter = MOUNT_DIAMETER + MOUNT_THICKNESS;    
    
    translate([0,0, MOUNT_HEIGHT/2])
    cylinder(MOUNT_HEIGHT*2, MOUNT_DIAMETER/2, MOUNT_DIAMETER/2, true);        
}

module vertical_bridge(height){
    translate([0,0, height/2])    
    cube([VERTICAL_BRIDGE_WIDTH, VERTICAL_BRIDGE_THICKNESS, height], true);      
}

module bridge_with_mount(){
    translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
    rotate([BRIDGE_ANGLE,0,0])    
    bridge(BRIDGE_WIDTH, MIN_BRIDGE_WIDTH, BRIDGE_HEIGHT, BRIDGE_THICKNESS);  
}

module bridge(wider_width, min_width, height, thickness){
    rounded_corners_trapeze(wider_width, min_width, height, thickness, CORNERS_DIAMETER);
}

module sma_hole(){
    color("grey")
    cylinder(BRIDGE_THICKNESS*20, SMA_HOLE_DIAMETER/2, SMA_HOLE_DIAMETER/2, true);            
}

module sma_outliner(){
    outliner_thickness = BRIDGE_THICKNESS*10;
    color("grey")    
    translate([0,0,outliner_thickness/2])    
    cylinder(outliner_thickness, SMA_OUTLINER_DIAMETER/2, SMA_OUTLINER_DIAMETER/2, true);            
}

module sma_plate(){
    outliner_thickness = BRIDGE_THICKNESS*20;
    color("grey")
    translate([0,0,outliner_thickness/2+BRIDGE_THICKNESS/2])
    cube([SMA_CUTOUT_WIDTH, SMA_CUTOUT_HEIGHT, outliner_thickness], true);            
}


module shelf(thickness){
    holder_thickness = thickness + 0.5;
    width = SHELF_WIDTH;
    
    translate([0,-SHELF_LENGTH/2-SHELF_Y_OFFSET,-thickness/2])
    difference(){
        cube([width, SHELF_LENGTH, thickness], true);
        translate([0,-4,0])        
        shelf_zipties(width, thickness);    
    }
    
//    straight_shelf_holders(width, holder_thickness);

//    translate([0,0,-MOUNT_HEIGHT+holder_thickness])
//    straight_shelf_holders(BRIDGE_WIDTH, holder_thickness);    
    
    angled_shelf_holders(width, holder_thickness);
    
//    translate([0,-15,0])
//    vtx(2);
}

module shelf_zipties(width, thickness){
    ziptie_cutout = (SHELF_WIDTH - VTX_WIDTH)/2;    
    x_offset = width/2 - ziptie_cutout/2;
    y_offset = 0;    
    
    union(){
        translate([x_offset, 0, 0])
        shelf_ziptie(ziptie_cutout, thickness);
        
        translate([-x_offset, 0, 0])
        shelf_ziptie(ziptie_cutout, thickness);    
    }         
}

module shelf_ziptie(ziptie_cutout, thickness){
    cube([ziptie_cutout, ZIPTIE_WIDTH, thickness*2], true);  
}

//module straight_shelf_holders(width, thickness){
//    angle = 90;
//    length1 = 10;
//    x_offset = width/2 - thickness/2;
//    y_offset = 2;
//    
//    translate([0,-y_offset,-thickness/2])
//    rotate([angle,0,0])
//    union(){
//        translate([x_offset, 0, 0])
//        shelf_holder(thickness, length1);
//        
//        translate([-x_offset, 0, 0])
//        shelf_holder(thickness, length1);    
//    }    
//}

module angled_shelf_holders(width, thickness){
    angle = 60;
    length1 = 14;
    x_offset = width/2 - thickness/2;
    y_offset = -2;
    
    translate([0,y_offset,0])
    union(){
        translate([x_offset, 0, 0])
        angled_shelf_holder(length1,thickness); 
        
        translate([-x_offset, 0, 0])
        angled_shelf_holder(length1,thickness); 
    }
}

module angled_shelf_holder(length, thickness){
    y_offset = 2.5;
    
    base_height = 1;
    base_width = 3;
    
    hull(){
        translate([0, 0, -MOUNT_HEIGHT+base_height/2])
        cube([thickness,base_width,base_height], true);
        
        translate([0, 0, -base_height/2])
        cube([thickness,base_width,base_height], true);
        
        translate([0, -length, -base_height/2])
        cube([thickness,base_width,base_height], true);
    }    
}

module shelf_holder(thickness, length){
    translate([0,0,length/2])
    cube([thickness, thickness, length], true);       
    
}

module arrow_arm(thickness){
    width = ARROWS_ARM_WIDTH;
    length = ARROWS_ARM_LENGTH;
    hull(){
        cylinder(thickness,width/2, width/2, true);

        translate([-length,0,0])
        cylinder(thickness,width/2, width/2, true);        
    }    
}

module arrows(thickness){
    angle = 45;
    
    rotate([0,0,angle])
    arrow_arm(thickness);
    
    rotate([0,0,180-angle])    
    arrow_arm(thickness);
}

module rounded_corners_trapeze(bottom_width, upper_width, height, depth, corner_curve){
    x_translate = bottom_width-corner_curve;
    x_translate2 = upper_width-corner_curve;    
    y_translate = height-corner_curve;
    
    
    hull(){
            translate([-x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);    
            
            translate([-x_translate2/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);

            translate([x_translate2/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
            
            translate([x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
    }        
}
